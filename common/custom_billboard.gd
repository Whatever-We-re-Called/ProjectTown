class_name CustomBillboard extends Node3D

@onready var parent_sprite: AnimatedSprite3D = get_parent()

func _ready():
	parent_sprite.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	parent_sprite.position.y += _get_current_sprite_height() / 10.0


func _get_current_sprite_height() -> float:
	var frame_index = parent_sprite.get_frame()
	var animation_name = parent_sprite.animation
	var current_frame = parent_sprite.sprite_frames.get_frame_texture(animation_name, frame_index)
	return current_frame.get_size().y / 100.0
