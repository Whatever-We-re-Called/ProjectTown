extends UIElement
class_name BreakLoop


@export var reference = Node


func execute():
	if reference is Loop:
		reference.recieved_break_instruction = true
	elif reference is UIItem:
		reference.break_loop.emit()
	elif reference == null and parent() is UIItem:
		parent().break_loop.emit()
