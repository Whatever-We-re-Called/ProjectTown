extends UIAction
class_name Group


func execute():
	for child in get_children():
		if child is UIExecutor:
			if child is Wait:
				await child.start_execute(true)
			else:
				child.start_execute(true)
