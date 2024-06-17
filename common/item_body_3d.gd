class_name ItemBody3D extends CharacterBody3D

@export var gracity_scale: float = 1.0

@onready var player = get_tree().get_first_node_in_group("player")

var freeze: bool = false
var collision_shapes: Array[CollisionShape3D]

const GRAVITY = 9.81


func _ready():
	for child in get_children():
		if child is CollisionShape3D:
			collision_shapes.append(child)


func _physics_process(delta):
	if freeze: return
	
	if not is_on_floor():
		velocity.y -= GRAVITY * gracity_scale * delta
	else:
		velocity = Vector3.ZERO
	
	move_and_slide()


func enable_collision_shapes(enabled: bool):
	for collision_shape in collision_shapes:
		collision_shape.disabled = not enabled
