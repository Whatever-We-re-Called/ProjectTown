extends Node
class_name DialogueExecutor


signal start_dialogue

func _process(delta):
	if not DialogueManager.current_dialogues.is_empty():
		var last = DialogueManager.current_dialogues[DialogueManager.current_dialogues.size() - 1]
		if last is DialogueBubble:
			if last.instance.next and last.instance.complete:
				var instance = last.instance.next
				var dialogue = preload("res://dialogue/scenes/dialogue.tscn").instantiate()
				
				dialogue.set_instance(instance)
				dialogue.on_complete.connect(_free.bind(dialogue))
				DialogueManager.current_dialogues.append(dialogue)
				
				last.add_child(dialogue)
				start_dialogue.emit()
				await get_tree().process_frame
				dialogue.start_typing()
		
	elif not DialogueManager.dialogue_queue.is_empty():
		var instance = DialogueManager.dialogue_queue.pop_front()
		
		if instance.response_options == null or instance.response_options.is_empty():
		
			var dialogue = preload("res://dialogue/scenes/dialogue.tscn").instantiate()
			
			dialogue.set_instance(instance)
			dialogue.on_complete.connect(_free.bind(dialogue))
			DialogueManager.current_dialogues.append(dialogue)
				
			var canvas = DialogueCanvas.new(get_tree())
			var node2d = Node2D.new()
			node2d.add_child(dialogue)
			canvas.add_child(node2d)
			start_dialogue.emit()
			
			await get_tree().process_frame
			dialogue.start_typing()
			
		else:
			var canvas = DialogueCanvas.new(get_tree())
			var holder = OptionHolder.new()
			holder.setup(instance)
			holder.name = "OptionHolder"
			holder.on_complete.connect(_free.bind(holder))
			DialogueManager.current_dialogues.append(holder)
			
			canvas.add_child(holder)
			start_dialogue.emit()
			
		
	
	if Input.is_action_just_pressed("dialogue_continue"):
		for dialogue in DialogueManager.current_dialogues:
			dialogue.handle_input("continue")
	if Input.is_action_just_pressed("dialogue_up"):
		for dialogue in DialogueManager.current_dialogues:
			dialogue.handle_input("select_up")
	if Input.is_action_just_pressed("dialogue_down"):
		for dialogue in DialogueManager.current_dialogues:
			dialogue.handle_input("select_down")


func _free(dialogue):
	if not dialogue.instance.next:
		if (dialogue.instance.previous
			or DialogueManager.dialogue_queue.is_empty()
			or dialogue is OptionHolder):
				
			
			for d in DialogueManager.current_dialogues:
				d.get_parent().queue_free()
			DialogueManager.current_dialogues.clear()
		else:
			var next = DialogueManager.dialogue_queue.front()
			if (dialogue.instance.character == next.character and
				dialogue.instance.position == next.position
				and next.parsed_text):
					
				await dialogue.set_next_text(next.parsed_text.to_bbcode_text())
				DialogueManager.current_dialogues.clear()
				await start_dialogue
				await get_tree().process_frame
				dialogue.get_parent().queue_free()
				
			else:
				for d in DialogueManager.current_dialogues:
					d.get_parent().queue_free()
				DialogueManager.current_dialogues.clear()
		
