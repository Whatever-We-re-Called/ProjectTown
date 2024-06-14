@tool
class_name DropShadow extends Decal

@export var parent_sprite: AnimatedSprite3D

const SHADOW_TEXTURE = preload("res://common/drop_shadow/shadow.png")

func _ready():
	sorting_offset = -100
	parent_sprite.frame_changed.connect(_setup_shadow)
	_setup_shadow()


func _process(delta):
	if Engine.is_editor_hint():
		_setup_shadow()


func _setup_shadow():
	if parent_sprite != null:
		var current_sprite_width = _get_current_sprite_width()
		size = Vector3(current_sprite_width / 1.5, 100.0, current_sprite_width / 1.5)
		position = Vector3(0.0, -49.9, 0.0)
		texture_albedo = SHADOW_TEXTURE
		upper_fade = 0.0
		lower_fade = 0.0


func _get_current_sprite_width() -> float:
	var frame_index = parent_sprite.get_frame()
	var animation_name = parent_sprite.animation
	var current_frame = parent_sprite.sprite_frames.get_frame_texture(animation_name, frame_index)
	return current_frame.get_size().x / 100.0
