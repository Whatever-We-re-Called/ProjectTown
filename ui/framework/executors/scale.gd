extends UIInterpolator
class_name Scale


@export var target = Vector2(1, 1)
var origin
var original_origin
var next_origin


func get_target():
	return target


func setup():
	if next_origin == null:
		original_origin = parent().scale
	if next_origin != null:
		origin = next_origin
		next_origin = null
	else:
		origin = original_origin


func execute_interpolation(time, style):
	parent().scale = interpolate(origin, target, time, style)
