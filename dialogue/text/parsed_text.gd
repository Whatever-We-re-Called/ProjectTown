extends Node
class_name ParsedText


static var shortcuts = preload("res://dialogue/text/tag_shortcuts.tres")


var input_text: String
var cleaned_text: String
var tags: Array
var used_variables: Dictionary


func _init(input_text: String, cleaned_text: String, tags: Array, used_variables: Dictionary):
	self.input_text = input_text
	self.cleaned_text = cleaned_text
	self.tags = _cleanup_tags(tags)
	self.used_variables = used_variables


func _cleanup_tags(tags: Array) -> Array:
	var cleaned_tags = []
	for tag in tags:
		var tag_name = tag[0]
		var tag_position = tag[1]
		
		for shortcut in shortcuts.shortcuts:
			if tag_name == shortcut.short:
				tag_name = shortcut.full
		
		for shortcut in shortcuts.colors:
			if tag_name == shortcut.key:
				tag_name = "color=#" + shortcut.color.to_html(true)
			
		cleaned_tags.append([tag_name, tag_position])
	
	return cleaned_tags


func get_tags_at_index(index: int) -> Array:
	var applied_tags = []
	
	for tag in tags:
		var tag_name = tag[0].replace(" = ", "=")
		var tag_position = tag[1]
		
		if tag_position > index:
			break
		
		if tag_name == "reset":
			applied_tags.clear()
			continue
		if tag_name.begins_with("color"):
			applied_tags = applied_tags.filter(func f(tag): 
				return not (tag.begins_with("color") or tag in ['b', 'i']))
		
		applied_tags.append(tag[0].replace(" = ", "="))
	
	return applied_tags
	
	
func to_bbcode_text(limit: int = -1) -> String:
	if limit < 0 or limit > cleaned_text.length() - 1:
		limit = cleaned_text.length()

	var bbcode_text = ""
	var opened_tags = []
	var previous_tags = []

	for i in range(min(limit, cleaned_text.length())):
		var current_tags = get_tags_at_index(i)

		previous_tags.reverse()
		for tag in previous_tags:
			if tag not in current_tags:
				bbcode_text += "[/" + tag.split("=")[0].strip_edges() + "]"
				opened_tags.erase(tag)
		previous_tags.reverse()

		for tag in current_tags:
			if tag not in opened_tags:
				bbcode_text += "[" + tag + "]"
				opened_tags.append(tag)

		bbcode_text += cleaned_text[i]

		previous_tags = current_tags

	opened_tags.reverse()
	for tag in opened_tags:
		bbcode_text += "[/" + tag.split("=")[0].strip_edges() + "]"

	return bbcode_text
