extends UIAction
class_name OnClick


@export var cooldown_in_seconds: float
var cooldown_active = false


func _ready():
	for child in parent().get_children():
		if child is Button:
			child.pressed.connect(execute)


func execute():
	if not cooldown_active:
		cooldown_active = true
		start()
	await timer(cooldown_in_seconds)
	cooldown_active = false
	
