@tool
extends StaticBody3D

@export var size: Vector3:
	get:
		return _size
	set(value):
		if value != _size and Engine.is_editor_hint():
			_update_size()
		_size = value

var _size: Vector3


func _update_size():
	if $CollisionShape3D != null:
		$CollisionShape3D.shape.size = _size
	if $MeshInstance3D != null:
		$MeshInstance3D.mesh.size = _size
