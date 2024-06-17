class_name InteractionArea extends Area3D

signal called
signal finished

@export var action_name: String = "Interact"
@export var label_y_offset: float = 0

var interact_callable: Callable = func():
	pass


func _ready():
	collision_layer = 0
	collision_mask = 2
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body):
	InteractionManager.register_area(self)


func _on_body_exited(body):
	InteractionManager.unregister_area(self)
