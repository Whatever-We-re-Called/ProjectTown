extends UIElement
class_name UIAction


func start():
	for child in get_children():
		if child is UIExecutor:
			await child.start_execute(false)
		elif child is UIAction:
			await child.execute()
