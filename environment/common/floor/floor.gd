@tool
extends StaticBody3D

@export var size: Vector2:
	get:
		return _size
	set(value):
		if value != _size and Engine.is_editor_hint():
			_size = value
			_update_size()

var _size: Vector2


func _update_size():
	if get_tree() == null: return
	await get_tree().process_frame
	
	if $CollisionShape3D != null:
		$CollisionShape3D.shape.size = Vector3(_size.x, 0.05, _size.y)
		$CollisionShape3D.position.y = -0.025
	if $MeshInstance3D != null:
		$MeshInstance3D.rotation_degrees.x = -90.0
		$MeshInstance3D.mesh.size = _size
