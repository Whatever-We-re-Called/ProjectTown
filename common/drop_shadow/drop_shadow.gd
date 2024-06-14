@tool
class_name DropShadow extends Decal

@export var update: bool = false:
	set(value):
		if Engine.is_editor_hint():
			_setup_shadow()
@export var collision: CollisionShape3D

const SHADOW_TEXTURE = preload("res://common/drop_shadow/shadow.png")

func _ready():
	_setup_shadow()


func _setup_shadow():
	if collision != null:
		var width = collision.shape.size.x
		size = Vector3(width, 100.0, width)
		position = Vector3(0.0, -49.995, 0.0)
		texture_albedo = SHADOW_TEXTURE
		upper_fade = 0.0
		lower_fade = 0.0
