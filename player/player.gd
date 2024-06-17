class_name Player extends CharacterBody3D

signal direction_changed(new_direction: Vector3)
signal picked_up_item
signal dropped_item

@export var physics_push_force: float

@onready var player_controller_states = $PlayerControllerStates
@onready var pick_up_slot = %PickUpSlot

var current_controller_state : PlayerControllerState
var controller_states : Dictionary = {}


func _ready():
	_init_controller_states()


func _init_controller_states():
	for child in player_controller_states.get_children():
		if child is PlayerControllerState:
			child.init(self)
			controller_states[child.name.to_lower()] = child
	change_to_controller_state("normal")


func _process(delta):
	if current_controller_state != null:
		current_controller_state._update(delta)


func _physics_process(delta):
	if current_controller_state != null:
		current_controller_state.calculate_pre_physics()
		current_controller_state._physics_update(delta)
		current_controller_state.calculate_post_physics()


func change_to_controller_state(new_controller_state_name: String):
	var new_controller_state = controller_states.get(new_controller_state_name.to_lower())
	if not new_controller_state: return
	if current_controller_state == new_controller_state: return
	
	if current_controller_state != null:
		current_controller_state._exit()
	
	new_controller_state._enter()
	
	current_controller_state = new_controller_state


func handle_physics_move():
	print(velocity)
	move_and_slide()
	print(velocity)
	#if move_and_slide():
		#for i in get_slide_collision_count():
			#var col = get_slide_collision(i)
			#if col.get_collider() is RigidBody3D:
				#print(col.get_collider_velocity())
				#if col.get_collider_velocity() == Vector3.DOWN:
					#col.get_collider().apply_force(col.get_normal() * -physics_push_force)


func pick_up_item(rigid_body: RigidBody3D):
	print("pick up")
	rigid_body.reparent(pick_up_slot)
	rigid_body.position = Vector3.ZERO
	rigid_body.freeze = true
	
	picked_up_item.emit()


func drop_item():
	if pick_up_slot.get_children().size() > 0:
		var rigid_body = pick_up_slot.get_children()[0]
		rigid_body.reparent(get_tree().root)
		rigid_body.freeze = false
		
		dropped_item.emit()


func _input(event):
	if event.is_action_pressed("interact") and pick_up_slot.get_children().size() > 0:
		drop_item()
