extends Node2D
class_name UIElement


@export var ui_parent: Node
@export var use_dynamic_parent = false


func parent(dynamic = false) -> Node:
	if ui_parent == null or dynamic:
		if get_parent() is UIElement:
			return get_parent().parent(dynamic or use_dynamic_parent)
		else:
			if dynamic:
				ui_parent = get_dynamic_parent()
			else:
				ui_parent = get_parent()
	return ui_parent

	
func get_dynamic_parent():
	pass
	
	
func execute():
	pass
	

func timer(time):
	await get_tree().create_timer(time * (1 - get_process_delta_time())).timeout 
	
	
enum InterpolationStyle {
	LINEAR,
	BEZIER,
	CUBIC_UP,
	CUBIC_DOWN
}
