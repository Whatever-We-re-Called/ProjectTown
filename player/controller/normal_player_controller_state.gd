class_name NormalPlayerControllerState extends PlayerControllerState

@export var movement_speed: float
@export var ground_acceleration: float
@export var ground_friction: float
@export var air_acceleration: float
@export var air_friction: float
@export var jump_velocity: float
@export var gravity_scale: float


func _physics_update(delta):
	apply_gravity(delta, gravity_scale)
	handle_ground_jump(jump_velocity)
	if player.is_on_floor():
		handle_horizontal_movement(movement_speed, ground_acceleration, ground_friction, delta)
	else:
		handle_horizontal_movement(movement_speed, air_acceleration, air_friction, delta)
	
	player.handle_physics_move()
