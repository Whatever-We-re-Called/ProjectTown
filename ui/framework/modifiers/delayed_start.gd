extends UIModifier
class_name DelayedStart


@export var delay_in_seconds: float


func execute():
	await timer(delay_in_seconds)
