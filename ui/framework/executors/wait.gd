extends UIExecutor
class_name Wait


@export var delay: float


func execute():
	await timer(delay)
