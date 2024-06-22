extends Node2D
class_name DialogueBubble

signal on_complete

const SCALE_1_SIZE = 115
var instance: DialogueInstance
var state = State.TYPING
var awaiting_finish_timeout = true
	
	
func set_instance(instance: DialogueInstance):
	self.instance = instance
	instance.scene = self
	
	$Text/RichTextLabel.bbcode_enabled = true
	$Text/RichTextLabel.visible_ratio = 0
	$Text/RichTextLabel.text = "[center]" + instance.parsed_text.to_bbcode_text()
	await DialogueManager.get_tree().process_frame
	
	if instance.previous:
		show_bubble_with_connector(instance.position, instance.previous)
	else:
		show_bubble_with_tail(instance.position)


func show_bubble_with_tail(position: DialogueManager.DialoguePosition):
	$Bubble.scale.y = _get_target_bubble_scale()
	$Bubble.position.y = -_get_target_bubble_height()
	
	var size = instance.get_character_rect()
	match position:
		DialogueManager.DialoguePosition.MIDDLE: self.position.y = -(size.y / 2) - 35
		DialogueManager.DialoguePosition.LEFT: self.position = Vector2(-(size.x / 2) - 95, -35)
		DialogueManager.DialoguePosition.RIGHT: self.position = Vector2((size.x / 2) + 95, -35)
	
	set_tail(position)


func show_bubble_with_connector(position: DialogueManager.DialoguePosition, previous):
	$Bubble.scale.y = _get_target_bubble_scale()
	$Bubble.position.y = -_get_target_bubble_height()
	
	self.position.y = -(previous.scene._get_target_bubble_height() * 2)
	match position:
		DialogueManager.DialoguePosition.LEFT: self.position.x = -75
		_: self.position.x = 75
	
	set_connector(position, previous)


func _get_target_bubble_height() -> float:
	return ($Bubble.texture.get_height() * _get_target_bubble_scale()) / 2


func _get_target_bubble_scale() -> float:
	return max(1, $Text/RichTextLabel.size.y / SCALE_1_SIZE)


func set_tail(position: DialogueManager.DialoguePosition):
	$Connector.visible = false
	$Tail.visible = true
	
	match position:
		DialogueManager.DialoguePosition.MIDDLE: $Tail/Middle.visible = true
		DialogueManager.DialoguePosition.RIGHT: $Tail/Left.visible = true
		DialogueManager.DialoguePosition.LEFT: $Tail/Right.visible = true


func set_connector(position: DialogueManager.DialoguePosition, previous):
	$Tail.visible = false
	$Connector.visible = true
	
	match position:
		DialogueManager.DialoguePosition.LEFT: $Connector/Right.visible = true
		_: $Connector/Left.visible = true


func start_typing():
	var target_time = 0.0
	if instance.auto_calculate or instance.timing_override == -1:
		target_time = float(instance.parsed_text.cleaned_text.length()) / UserSettings.type_speed
	elif not instance.auto_calculate:
		target_time = instance.timing_override
		
	var time = 0.0
	while $Text/RichTextLabel.visible_ratio < 1:
		time += get_process_delta_time()
		$Text/RichTextLabel.visible_ratio = min(1, time / target_time)
		await get_tree().process_frame
		
	await _set_state_finished()
	if instance.auto_continue:
		await get_tree().create_timer(instance.linger_time).timeout
		instance.complete = true
		on_complete.emit()


func handle_input(type: String):
	if type != "continue":
		return
	
	if state == State.TYPING:
		$Text/RichTextLabel.visible_ratio = 1
		_set_state_finished()
	else:
		if not awaiting_finish_timeout:
			instance.complete = true
			on_complete.emit()


func _set_state_finished():
	state = State.FINISHED
	await get_tree().create_timer(.1).timeout
	awaiting_finish_timeout = false


func _process(_delta):
	$Text.position = $Bubble.position - ($Text.size / 2)
	$Text.z_index = 1

enum State {
	TYPING,
	FINISHED
}
