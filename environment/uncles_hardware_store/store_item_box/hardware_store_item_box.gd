extends RigidBody3D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var interaction_area = %InteractionArea

func _on_interaction_area_called():
	print("called")
	player.pick_up_item(self)
	await player.dropped_item
	
	interaction_area.finished.emit()
