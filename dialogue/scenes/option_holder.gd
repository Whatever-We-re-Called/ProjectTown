extends Node2D
class_name OptionHolder


signal on_complete

var instance: DialogueInstance
var selected_index = -1
var options: Array[ResponseOption]


func setup(instance: DialogueInstance):
	self.instance = instance
	self.options = instance.response_options
	
	var total_size = 0
	var used_size = 0
	
	var node2d = Node2D.new()
	
	for i in options.size():
		var dialogue = preload("res://dialogue/scenes/option_dialogue.tscn").instantiate()
	
		dialogue.select.connect(_select)
		node2d.add_child(dialogue)
		dialogue.set_option(instance, i)
		total_size += dialogue.get_child(0).size.y + 30
		
	for dialogue in node2d.get_children():
		dialogue.position.y = used_size + dialogue.get_child(0).size.y + 15
		used_size += dialogue.get_child(0).size.y + 15
		
	node2d.position.x = (instance.get_character_rect().x / 2) + 30
	node2d.position.y = -total_size / 2
	
	add_child(node2d)
		
		
func _select(index):
	selected_index = index
	_set_selected_node()
	
	
func handle_input(type: String):
	if type == "select_up":
		selected_index -= 1
		if selected_index == -1:
			selected_index = options.size() - 1
		_set_selected_node()
		
	elif type == "select_down":
		selected_index += 1
		if selected_index == options.size():
			selected_index = 0
		_set_selected_node()
		
	elif type == "continue":
		var option = options[selected_index if selected_index > -1 else 0]
		var player = DialogueManager._find_speaker_in_tree(Constants.Character.PLAYER)
		
		var dialogue_instance = DialogueInstance.new(option.text, player)
		dialogue_instance.position = DialogueManager.DialoguePosition.MIDDLE
		DialogueManager.queue_raw(dialogue_instance)
		DialogueManager.queue(option.following_conversation)
		
		on_complete.emit()


func _set_selected_node():
	for child in get_child(0).get_children():
		child.set_selected(false)
	get_child(0).get_children()[selected_index].set_selected(true)
