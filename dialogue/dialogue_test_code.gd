extends Node


func _process(_delta):
	if Input.is_action_just_pressed("debug_1"):
		DialogueManager.queue("conversation.test")
