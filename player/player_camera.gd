extends Camera3D

@export var target_player: Player
@export var position_offset: Vector3
@export var directional_offset_strength: float
@export var speed: float

var previous_global_position: Vector3 = Vector3.ZERO
var old_global_position: Vector3
var lerp_position_delta_index: float
var current_directional_offset: Vector3


func _ready():
	target_player.direction_changed.connect(_update_directional_offset)


func _physics_process(delta):
	var target_global_position = target_player.global_position + position_offset + current_directional_offset
	_lerp_position(target_global_position, speed * delta)


func _lerp_position(new_target_global_position: Vector3, delta: float):
	if new_target_global_position != previous_global_position:
		previous_global_position = new_target_global_position
		old_global_position = global_position
		lerp_position_delta_index = 0.0
	
	lerp_position_delta_index += delta
	lerp_position_delta_index = clamp(lerp_position_delta_index, 0.0, 1.0)
	
	global_position.x = EasingFunctions.ease_out_cubic(old_global_position.x, new_target_global_position.x, lerp_position_delta_index)
	global_position.y = EasingFunctions.ease_out_cubic(old_global_position.y, new_target_global_position.y, lerp_position_delta_index)
	global_position.z = EasingFunctions.ease_out_cubic(old_global_position.z, new_target_global_position.z, lerp_position_delta_index)


func _update_directional_offset(changed_to_direction: Vector3):
	current_directional_offset = changed_to_direction.normalized() * directional_offset_strength
	pass
