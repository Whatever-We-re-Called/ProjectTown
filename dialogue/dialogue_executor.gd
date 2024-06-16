extends Node
class_name DialogueExecutor


func _process(delta):
	if not DialogueManager.current_dialogues.is_empty():
		var last = DialogueManager.current_dialogues[DialogueManager.current_dialogues.size() - 1]
		if last.instance.next and last.instance.complete:
			var instance = last.instance.next
			var dialogue = preload("res://dialogue/scenes/dialogue.tscn").instantiate()
			
			dialogue.set_instance(instance)
			dialogue.on_complete.connect(_free.bind(dialogue))
			DialogueManager.current_dialogues.append(dialogue)
			
			last.add_child(dialogue)
			await get_tree().process_frame
			dialogue.start_typing()
		
	elif not DialogueManager.dialogue_queue.is_empty():
		var instance = DialogueManager.dialogue_queue.pop_front()
		var dialogue = preload("res://dialogue/scenes/dialogue.tscn").instantiate()
		
		dialogue.set_instance(instance)
		dialogue.on_complete.connect(_free.bind(dialogue))
		DialogueManager.current_dialogues.append(dialogue)
		
		var size = _get_node_rect(instance.character)
		match instance.position:
			DialogueManager.DialoguePosition.MIDDLE: dialogue.position.y = (size.y / 2) + .75
			DialogueManager.DialoguePosition.LEFT: dialogue.position = Vector3(-(size.x / 2) - 1.3, .75, 0)
			DialogueManager.DialoguePosition.RIGHT: dialogue.position = Vector3((size.x / 2) + 1.3, .75, 0)
			
		instance.character.add_child(dialogue)
		
		await get_tree().process_frame
		dialogue.start_typing()
		
	
	if Input.is_action_just_pressed("dialogue_continue"):
		for dialogue in DialogueManager.current_dialogues:
			dialogue.handle_input()


func _get_node_rect(node):
	if node is AnimatedSprite3D:
		return node.sprite_frames.get_frame_texture(node.animation, 0).get_size() * node.pixel_size
	if node is Sprite3D:
		return node.texture.get_size() * node.pixel_size


func _free(dialogue):
	if not dialogue.instance.next:
		for d in DialogueManager.current_dialogues:
			d.queue_free()
		DialogueManager.current_dialogues.clear()
		
