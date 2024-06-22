extends UIExecutor
class_name UIInterpolator

@export var seconds = 1.0
@export var style = InterpolationStyle.LINEAR

var i = 0
var current_ratio
var stopped = false
var running = false


func setup():
	pass


func execute():
	if running:
		return
	
	setup()
	running = true
	while true:
		if stopped:
			i = 0
			stopped = false
			break
		execute_interpolation(i / seconds if seconds > 0 else 1, style)
		current_ratio = (i / seconds) if seconds > 0 else 1
		if i == seconds:
			i = 0
			break
		i += get_process_delta_time()
		if i > seconds:
			i = 0
			break
		await get_tree().process_frame
	running = false


func execute_interpolation(time, style):
	pass
	
	
	
func get_target():
	pass
	

func stop() -> Dictionary:
	if running:
		stopped = true
	running = false
	if seconds == 0 or (current_ratio != null and current_ratio >= 1):
		return { "i": 0, "target": null }
	return { "i": current_ratio if current_ratio != null else 0, "target": get_target() }
