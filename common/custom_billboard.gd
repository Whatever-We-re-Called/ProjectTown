@tool
class_name CustomBillboard extends Node3D

@export var update: bool = false:
	set(value):
		_update()

@onready var parent_sprite: AnimatedSprite3D = get_parent()

func _ready():
	_update()
	parent_sprite.frame_changed.connect(_update)


func _update():
	parent_sprite.rotation_degrees.x = -45.0
	var height = _get_current_sprite_height()
	var result = height - (cos(deg_to_rad(45.0) / height)) - (height / 2.0)
	parent_sprite.position = Vector3(0, result, 0)


func _get_current_sprite_height() -> float:
	var frame_index = parent_sprite.get_frame()
	var animation_name = parent_sprite.animation
	var current_frame = parent_sprite.sprite_frames.get_frame_texture(animation_name, frame_index)
	return current_frame.get_size().y * parent_sprite.pixel_size
