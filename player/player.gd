class_name Player extends CharacterBody3D

signal direction_changed(new_direction: Vector3)

@onready var player_controller_states = $PlayerControllerStates

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
