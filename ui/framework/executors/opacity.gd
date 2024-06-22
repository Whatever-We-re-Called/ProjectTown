extends UIInterpolator
class_name Opacity


@export var target = 0.0
var origin: float
var original_origin
var next_origin


func get_target():
	return target


func setup():
	if next_origin == null:
		original_origin = parent().modulate.a
		
	if next_origin != null:
		origin = next_origin
		next_origin = null
	else:
		origin = original_origin


func execute_interpolation(time, style):
	parent().modulate.a = interpolate(origin, target, time, style)
