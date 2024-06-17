# Initially yoinked from https://youtu.be/ajCraxGAeYU?si=wkLHIG_Buhvy_PVt.
extends Node3D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var interaction_sprite = %InteractionSprite
@onready var interact_label = %InteractLabel

const BASE_TEXT = "[E] "

var active_areas = []
var can_interact = true


func _process(delta):
	print(active_areas.size(), " ", can_interact)
	if active_areas.size() > 0 and can_interact:
		print("A")
		active_areas.sort_custom(_sort_by_distance_to_player)
		interact_label.text = BASE_TEXT + active_areas[0].action_name
		interaction_sprite.global_position = active_areas[0].global_position
		interaction_sprite.global_position.y += active_areas[0].label_y_offset
		interaction_sprite.rotation_degrees.x = -45.0
		interaction_sprite.show()
	else:
		interaction_sprite.hide()


func _sort_by_distance_to_player(area1: InteractionArea, area2: InteractionArea):
	var area1_to_player = player.global_position.distance_to(area1.global_position)
	var area2_to_player = player.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player


func register_area(area: InteractionArea):
	active_areas.push_back(area)


func unregister_area(area: InteractionArea):
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)


func _input(event):
	if event.is_action_pressed("interact") and can_interact:
		if active_areas.size() > 0:
			var active_area = active_areas[0]
			
			can_interact = false
			interact_label.hide()
			active_area.called.emit()
			await active_area.finished
			
			can_interact = true
