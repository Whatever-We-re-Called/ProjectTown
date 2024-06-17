extends ItemBody3D

@onready var interaction_area = %InteractionArea

func _on_interaction_area_called():
	player.pick_up_item(self)
	await player.dropped_item
	
	interaction_area.finished.emit()
