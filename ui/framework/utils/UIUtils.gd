extends Node
class_name UIUtils


static func interpolate(a, b, time: float, style):
	if a is Vector2 and b is Vector2:
		if style == 0: # Linear
			return a.lerp(b, time)
		elif style == 1: # Bezier
			return a.lerp(b, ease(time, -2))
		elif style == 2: # Cubic Up
			var prePost = Vector2(min(a.x, b.x), max(a.y, b.y))
			return a.cubic_interpolate(b, prePost, prePost, time)
		elif style == 3: # Cubic Down
			var prePost = Vector2(max(a.x, b.x), min(a.y, b.y))
			return a.cubic_interpolate(b, prePost, prePost, time)
		else:
			printerr("Invalid Interpolation Style: " + style)
			
	if (a is Vector3 and b is Vector3) or (a is Vector4 and b is Vector4):
		if style == 0: # Linear
			return a.lerp(b, time)
		elif style == 1: # Bezier
			return a.lerp(b, ease(time, -2))
		else:
			printerr("Invalid Interpolation Style: " + style)
			
	elif a is float and b is float:
		if style == 0: # Linear
			return lerpf(a, b, time)
		elif style == 1: # Bezier
			return ease(lerpf(a, b, time), -2)
			
	else:
		printerr("Cannot interpolate between different types")
		printerr("Received: " + str(a) + " and " + str(b))
	return null
