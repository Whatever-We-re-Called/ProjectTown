class_name PlayerControllerState extends Node

var player: Player

var lerp_velocity_previous_x_target: float
var lerp_velocity_old_x: float
var lerp_velocity_previous_z_target: float
var lerp_velocity_old_z: float
var lerp_velocity_delta_index: float

const GRAVITY: float = 9.81


func init(player: Player):
	self.player = player


func _enter():
	pass


func _exit():
	pass


func _update(delta):
	pass


func _physics_update(delta):
	pass


func handle_movement(speed: float, acceleration: float, friction: float, delta: float):
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (player.transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	
	if direction != Vector3.ZERO:
		player.direction_changed.emit(direction)
		_lerp_velocity(direction.x * speed, direction.z * speed, acceleration * delta)
	else:
		_lerp_velocity(0.0, 0.0, friction * delta)


func _lerp_velocity(new_x_target: float, new_z_target: float, delta: float):
	if new_x_target != lerp_velocity_previous_x_target or new_z_target != lerp_velocity_previous_z_target:
		lerp_velocity_previous_x_target = new_x_target
		lerp_velocity_old_x = player.velocity.x
		lerp_velocity_previous_z_target = new_z_target
		lerp_velocity_old_z = player.velocity.z
		lerp_velocity_delta_index = 0.0
	
	lerp_velocity_delta_index += delta
	lerp_velocity_delta_index = clamp(lerp_velocity_delta_index, 0.0, 1.0)
	
	player.velocity.x = lerp(lerp_velocity_old_x, new_x_target, lerp_velocity_delta_index)
	player.velocity.z = lerp(lerp_velocity_old_z, new_z_target, lerp_velocity_delta_index)


func apply_gravity(delta: float, gravity_scale: float = 1.0):
	player.velocity.y -= GRAVITY * gravity_scale * delta


func handle_jump(jump_velocity: float):
	if Input.is_action_just_pressed("jump"):
		player.velocity.y = jump_velocity
