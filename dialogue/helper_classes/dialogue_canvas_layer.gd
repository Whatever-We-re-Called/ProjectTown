extends CanvasLayer
class_name DialogueCanvas


var camera: Camera3D


func _init(tree):
	tree.root.add_child(self)
	camera = tree.get_first_node_in_group("cameras")
	visible = false


func _process(_delta):
	if get_child_count() == 0:
		queue_free()
	else:
		for child in get_children():
			if not is_instance_valid(child):
				continue
				
			if child is OptionHolder:
				if child.get_child_count() > 0:
					var node3d = child.get_child(0).get_child(0).instance.character
					var pos = camera.unproject_position(node3d.global_position)
					child.position = pos
					visible = true
			else:
				var node3d = child.get_child(0).instance.character
				var pos = camera.unproject_position(node3d.global_position)
				child.position = pos
				visible = true
