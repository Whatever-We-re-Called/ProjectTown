# Needed executors:
# - Animation
#	- animation (string)
#	- loop = false
#	- action = (play, stop)
#
# Needed modifiers:
# - Overshoot?


extends UIElement
class_name UIExecutor


func start_execute(grouped):
	for child in get_children():
		if child is UIModifier:
			await child.execute()
	if not grouped or self is Wait:
		await execute()
	else:
		execute()


func interpolate(a, b, time, style):
	return UIUtils.interpolate(a, b, time, style)
