extends UIAction
class_name Loop


@export var loop_limit = 0
var recieved_break_instruction = false


func execute():
	if parent() is UIItem:
		parent().loop_break.connect(func rbi(): recieved_break_instruction = true)
	
	recieved_break_instruction = true
	
	var i = 0
	var loops = 0
	while true:
		var child = get_children()[i]
		if recieved_break_instruction:
			break
		if child is UIExecutor:
			await child.start_execute(false)
		elif child is UIAction:
			await child.execute()
		i += 1
		if i == get_children().size():
			i = 0
			loops += 1
			if loops == loop_limit:
				break
