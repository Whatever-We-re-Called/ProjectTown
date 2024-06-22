extends UIBoundingBoxHandler
class_name OnHoverExit


@export var associated_enter: OnHoverEnter


func exit():
	if associated_enter != null:
		for child in associated_enter.get_children():
			if not child is UIInterpolator:
				continue
				
			var dict = child.stop()
			for node in get_children():
				if node.get_class() == child.get_class():
					if dict.i > 0:
						node.i = (1.0 - dict.i) * node.seconds
						node.next_origin = dict.target
				
	start()
	
