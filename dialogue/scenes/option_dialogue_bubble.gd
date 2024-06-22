extends Node2D


signal select(int)

var instance: DialogueInstance 
var index: int
var selected: bool

var option: ResponseOption
var parsed_text: ParsedText


func set_option(instance: DialogueInstance, index: int):
	self.instance = instance
	self.index = index
	self.option = instance.response_options[index]
	self.parsed_text = TextParser.parse(option.text)
	
	var label = $RichTextLabel
	var bubble = $NinePatchRect
	
	label.text = self.parsed_text.to_bbcode_text()
	await DialogueManager.get_tree().process_frame
	
	bubble.size.x = label.get_content_width() + 40
	bubble.size.y = label.get_content_height() + 15
	
	bubble.position.y = bubble.size.y / -2
	
	label.position.x = 20
	label.position.y = label.size.y / -2
	
	$Button.size = bubble.size
	$Button.position = bubble.position
	
	if instance.response_options.size() > 1:
		match index:
			0: $Tail/Top.visible = true
			var x when index == instance.response_options.size() - 1: $Tail/Bottom.visible = true
			_: $Tail/Middle.visible = true
	
	
var received_break_instruction = false
	
func set_selected(selected: bool):
	received_break_instruction = true
	await get_tree().process_frame
	if selected and not self.selected:
		var time = 0.0
		received_break_instruction = false
		while time <= .1:
			if received_break_instruction:
				break
			time += get_process_delta_time()
			var scale = UIUtils.interpolate(1.0, 1.2, time / .1, UIElement.InterpolationStyle.LINEAR)
			self.scale = Vector2(scale, scale)
			await get_tree().process_frame
	
	if not selected and self.selected:
		var time = 0.0
		received_break_instruction = false
		while time <= .1:
			if received_break_instruction:
				break
			time += get_process_delta_time()
			var scale = UIUtils.interpolate(1.2, 1.0, time / .1, UIElement.InterpolationStyle.LINEAR)
			self.scale = Vector2(scale, scale)
			await get_tree().process_frame
		
	self.selected = selected


func _on_button_mouse_entered():
	select.emit(index)
