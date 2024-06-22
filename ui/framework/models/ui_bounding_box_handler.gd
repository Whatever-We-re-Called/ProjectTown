extends UIAction
class_name UIBoundingBoxHandler


@export var overide_bounding_boxes: Array[Node]
var bounding_boxes = []
var is_inside_arr = []
var inside


func _ready():
	for i in get_controls().size():
		is_inside_arr.append(false)
		get_controls()[i].mouse_entered.connect(func t(): is_inside_arr[i] = true)
		get_controls()[i].mouse_exited.connect(func f(): is_inside_arr[i] = false)


func _process(delta):
	if inside:
		if not is_inside():
			await get_tree().process_frame
			if not is_inside():
				inside = false
				exit()
	else:
		if is_inside():
			await get_tree().process_frame
			if is_inside():
				inside = true
				enter()


func get_controls():
	if overide_bounding_boxes != null and overide_bounding_boxes.size() > 0:
		return overide_bounding_boxes
		
	else:
		if bounding_boxes == null or bounding_boxes.size() == 0:
			var controls = []
			for child in parent().get_children():
				if child is Control:
					controls.append(child)
			bounding_boxes = controls
			return controls
		else:
			return bounding_boxes
			

func is_inside() -> bool:
	for i in is_inside_arr.size():
		if is_inside_arr[i] and get_controls()[i].visible:
			return true
	return false


func enter():
	pass


func exit():
	pass
