extends UIInterpolator
class_name ColorChange


@export var target: Color
@export var mode = Mode.HSV


var origin
var original_origin
var next_origin
var final


func get_target():
	return target


func setup():
	var init = parent().modulate
	if next_origin == null:
		original_origin = Vector3(init.r, init.g, init.b)
		
	if next_origin != null:
		origin = next_origin
		next_origin = null
	else:
		origin = original_origin
		
	final = Vector3(target.r, target.g, target.b)
	if mode == Mode.HSV:
		origin = rgb_to_hsv(origin)
		final = rgb_to_hsv(final)


func execute_interpolation(time, style):
	var current = interpolate(origin, final, time, style)
	if mode == Mode.HSV:
		current = hsv_to_rgb(current)
		
	parent().modulate = Color(current.x, current.y, current.z, parent().modulate.a)
	
	
# https://stackoverflow.com/questions/33975014/converting-rgb-to-hsv
func rgb_to_hsv(rgb: Vector3) -> Vector3:
	var r = rgb.x
	var g = rgb.y
	var b = rgb.z
	
	var min = min(r, g, b)
	var max = max(r, g, b)
	var delta = max - min
	
	var h = max
	var s = max
	var v = max
	
	if delta == 0:
		h = 0
		s = 0
		
	else:
		s = delta / max
		var del_r = (((max - r) / 6.0) + (delta / 2.0)) / delta
		var del_g = (((max - g) / 6.0) + (delta / 2.0)) / delta
		var del_b = (((max - b) / 6.0) + (delta / 2.0)) / delta
		
		if r == max:
			h = del_b - del_g
		elif g == max:
			h = (1.0 / 3.0) + del_r - del_b
		elif b == max:
			h = (2.0 / 3.0) + del_g - del_r
			
		if h < 0:
			h += 1
		if h > 1:
			h -= 1
			
	return Vector3(h, s, v)


# https://stackoverflow.com/a/7901693/19164629
func hsv_to_rgb(hsv: Vector3) -> Vector3:
	var hue = hsv.x
	var sat = hsv.y
	var val = hsv.z
	
	var h = int(hue * 6)
	var f = hue * 6 - h
	var p = val * (1 - sat)
	var q = val * (1 - f * sat)
	var t = val * (1 - (1 - f) * sat)
	
	var r
	var g
	var b
	
	if h == 0:
		r = val
		g = t
		b = p
	elif h == 1:
		r = q
		g = val
		b = p
	elif h == 2:
		r = p
		g = val
		b = t
	elif h == 3:
		r = p
		g = q
		b = val
	elif h == 4:
		r = t
		g = p
		b = val
	elif h <= 6:
		r = val
		g = p
		b = q
	
	return Vector3(r, g, b)
	

enum Mode {
	RGB,
	HSV
}
