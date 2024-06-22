extends UIElement
class_name Tooltip


func get_dynamic_parent():
	for child in get_parent().get_children():
		if child.name == "TooltipText":
			return child
	return null
	
	
func show_tooltip():
	get_dynamic_parent().visible = true
	
func hide_tooltip():
	get_dynamic_parent().visible = false
