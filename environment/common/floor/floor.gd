@tool
extends StaticBody3D

@export var size: Vector3:
	get:
		return _size
	set(value):
		if value != _size and Engine.is_editor_hint():
			_size = value
			_update_size()

var _size: Vector3


func _update_size():
	if get_tree() == null: return
	await get_tree().process_frame
	
	if $CollisionShape3D != null:
		$CollisionShape3D.shape.size = _size
	if $MeshInstance3D != null:
		$MeshInstance3D.mesh.size = _size
