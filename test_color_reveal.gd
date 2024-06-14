extends Node

@export var cv : ColorReveal

func _process(_delta):
	if Input.is_action_just_pressed("debug_1"):
		cv.reveal()
	if Input.is_action_just_pressed("debug_2"):
		cv._create_mask()
