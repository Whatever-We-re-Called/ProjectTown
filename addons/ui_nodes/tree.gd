@tool
extends Node

@export var elements: UIElementResource
@export var presets: UIElementResource

@export var folder_icon: Texture2D
	
var is_self_being_hovered_over = false
var waiting_on_double_click = false


func _ready():
	for child in get_children():
		remove_child(child)
		child.free()
		
	var elements_tree = Tree.new()
	elements_tree.name = "Elements"
	add_child(elements_tree)
	load_items(elements, elements_tree, null)
	
	var presets_tree = Tree.new()
	presets_tree.name = "Presets"
	add_child(presets_tree)
	var root = load_items(presets, presets_tree, null)
	
	var add_item = presets_tree.create_item(root)
	add_item.set_text(0, "[Add Preset]")
	
	handle_self_connected_signals(self)
	
var node_index = 0
func load_items(resource, tree, parent):
	if parent == null: node_index = 0
	var node = new_item(resource, tree, parent)
	for child in resource.children:
		load_items(child, tree, node)
	return node
	
	
func new_item(resource, tree, parent):
	var node = tree.create_item(parent)
	node.set_text(0, resource.name)
	node.set_icon(0, resource.icon)
	node.set_icon_max_width(0, 15)
	node.set_metadata(0, resource)
	resource.index = node_index
	node_index += 1
	return node


func handle_self_connected_signals(parent):
	if parent.get_children().size() == 0: return
	
	for child in parent.get_children():
		child.mouse_entered.connect(_on_mouse_entered)
		child.mouse_exited.connect(_on_mouse_exited)
		handle_self_connected_signals(child)


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				if is_self_being_hovered_over:
					if _get_active_tree().get_selected():
						if waiting_on_double_click:
							add_item_to_scene(_get_active_tree().get_selected())
						else:
							wait_on_double_click()
							
								
		elif event.button_index == MOUSE_BUTTON_MIDDLE:
			if not event.is_pressed():
				if is_self_being_hovered_over:
					if _get_active_tree().name == "Presets":
						if _get_active_tree().get_selected():
								if _get_active_tree().get_selected().get_text(0) != "Presets":
									remove_from_tree(_get_active_tree().get_selected())
				
				
func wait_on_double_click():
	waiting_on_double_click = true
	await get_tree().create_timer(.5).timeout
	waiting_on_double_click = false


func add_item_to_scene(resource):
	if resource.get_metadata(0):
		resource = resource.get_metadata(0)
	else:
		if resource.get_text(0) == "[Add Preset]":
			open_add_preset_popup()
		return
	
	for node in EditorInterface.get_selection().get_selected_nodes():
		var element
		
		if resource.script_file:
			if resource.script_file.resource_path.ends_with(".gd"):
				element = resource.script_file.new()
			else:
				element = resource.script_file.instantiate()
			
			
		node.add_child(element)
		element.owner = get_tree().edited_scene_root
		element.name = resource.name
		await get_tree().process_frame
		EditorInterface.edit_node(element)


func open_add_preset_popup(selected_group = 0, name = "", path = ""):
	var dialog = ConfirmationDialog.new()
	dialog.title = "Add Preset"
	dialog.size = Vector2(200, 100)
	get_tree().root.add_child(dialog)
	
	var vbox = VBoxContainer.new()
	dialog.add_child(vbox)
	
	var nested_hbox = HBoxContainer.new()
	vbox.add_child(nested_hbox)
	
	var nested_label = Label.new()
	nested_label.text = "Nested Under:"
	nested_hbox.add_child(nested_label)
	
	var nested_under = OptionButton.new()
	nested_under.custom_minimum_size = Vector2(223, 0)
	var groups = get_current_items(presets)
	for item in groups:
		nested_under.add_item(item.name)
	nested_hbox.add_child(nested_under)
	nested_under.selected = selected_group
			
	var name_hbox = HBoxContainer.new()
	vbox.add_child(name_hbox)
	
	var name_label = Label.new()
	name_label.text = "Name:"
	name_hbox.add_child(name_label)
	
	var name_box = TextEdit.new()
	name_box.scroll_fit_content_height = true
	name_box.text = name
	name_box.custom_minimum_size = Vector2(275, 0)
	name_hbox.add_child(name_box)
	
	var resource_hbox = HBoxContainer.new()
	vbox.add_child(resource_hbox)
	
	var resource_label = Label.new()
	resource_label.text = "Path:   "
	resource_hbox.add_child(resource_label)
	
	var resource_box = TextEdit.new()
	resource_box.scroll_fit_content_height = true
	resource_box.text = path
	resource_box.custom_minimum_size = Vector2(235, 0)
	resource_hbox.add_child(resource_box)
	
	var resource_file_button = Button.new()
	resource_file_button.icon = folder_icon
	resource_file_button.expand_icon = true
	resource_file_button.focus_mode = Control.FOCUS_NONE
	resource_file_button.custom_minimum_size = Vector2(35, 0)
	
	resource_file_button.pressed.connect(func open_file_selector():
		var file_selector = EditorFileDialog.new()
		file_selector.exclusive = false
		file_selector.file_mode = EditorFileDialog.FILE_MODE_OPEN_FILE
		get_tree().root.add_child(file_selector)
		file_selector.popup_on_parent(Rect2i(get_tree().root.size / 2 - file_selector.size, file_selector.size))
		file_selector.file_selected.connect(func file_selected(path): resource_box.text = path)
	)
	resource_hbox.add_child(resource_file_button)
	
	dialog.confirmed.connect(func save(): save_new_preset(nested_under.selected, name_box.text, resource_box.text))
	
	dialog.popup_on_parent(Rect2i(get_tree().root.size / 2 - dialog.size, dialog.size))


func save_new_preset(nested_under, name, path):
	if name == null or name == "":
		var dialog = ConfirmationDialog.new()
		dialog.title = "Error"
		dialog.size = Vector2(200, 100)
		dialog.dialog_text = "Name must be specified"
		get_tree().root.add_child(dialog)
		
		dialog.confirmed.connect(open_add_preset_popup.bind(nested_under, name, path))
		dialog.popup_on_parent(Rect2i(get_tree().root.size / 2 - dialog.size, dialog.size))
		return
		
	var ui_resource = UIElementResource.new()
	ui_resource.name = name
	
	if path.ends_with(".tscn"):
		var scene: PackedScene = load(path)
		ui_resource.script_file = scene
	elif path.ends_with(".gd"):
		var scene: GDScript = load(path)
	
	get_current_items(presets)[nested_under].children.append(ui_resource)
	save_presets_resource()
	
	_get_active_tree().clear()
	var root = load_items(presets, _get_active_tree(), null)
	var add_item = _get_active_tree().create_item(root)
	add_item.set_text(0, "[Add Preset]")


func get_current_items(item) -> Array:
	var arr = []
	arr.append(item)
	for child in item.children:
		arr.append_array(get_current_items(child))
	return arr


func remove_from_tree(item):
	var dialog = ConfirmationDialog.new()
	dialog.title = "Delete " + item.get_text(0) + "?"
	dialog.dialog_text = "Are you sure you want to delete preset " + item.get_text(0) + "?"
	dialog.size = Vector2(200, 50)
	dialog.confirmed.connect(delete_preset.bind(item))
	get_tree().root.add_child(dialog)
	dialog.popup_on_parent(Rect2i(get_tree().root.size / 2 - dialog.size, dialog.size))
	
	
func delete_preset(item):
	for node in get_current_items(presets):
		if node.index == item.get_parent().get_metadata(0).index:
			var index = 0
			for child_index in node.children.size():
				if node.children[child_index].index == item.get_metadata(0).index:
					index = child_index
			node.children.remove_at(index)
	save_presets_resource()
					
	_get_active_tree().clear()
	var root = load_items(presets, _get_active_tree(), null)
	var add_item = _get_active_tree().create_item(root)
	add_item.set_text(0, "[Add Preset]")
	
	
func save_presets_resource():
	ResourceSaver.save(presets, "res://addons/ui_nodes/presets.tres")
		

func _get_active_tree() -> Tree:
	for container in get_children():
		if container.visible:
			return container
	return null


func _on_mouse_entered():
	is_self_being_hovered_over = true


func _on_mouse_exited():
	is_self_being_hovered_over = false
