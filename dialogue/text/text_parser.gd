extends Node
class_name TextParser


static var variables = {}


static func parse(input_text: String) -> ParsedText:
	if not input_text or input_text == "":
		return null
	
	var variable_pattern = RegEx.new()
	variable_pattern.compile(r'\{\{(.*?)\}\}')

	var matches = variable_pattern.search_all(input_text)
	var cleaned_text = ""
	var last_index = 0
	var used_variables = {}
	
	for match in matches:
		var start = match.get_start()
		var end = match.get_end()
		var variable_name = match.get_string(1)
		
		cleaned_text += input_text.substr(last_index, start - last_index)
		
		if variables.has(variable_name):
			cleaned_text += str(variables[variable_name])
			used_variables[variable_name] = variables[variable_name]
		
		last_index = end
	
	cleaned_text += input_text.substr(last_index, input_text.length() - last_index)
	
	var tag_pattern = RegEx.new()
	tag_pattern.compile(r'\{(.*?)\}')
	
	matches = tag_pattern.search_all(cleaned_text)
	var final_text = ""
	var tags = []
	last_index = 0
	var adjustment = 0
	
	for match in matches:
		var start = match.get_start()
		var end = match.get_end()
		var tag_name = match.get_string(1)
		
		final_text += cleaned_text.substr(last_index, start - last_index)
		
		var tag_position = start - adjustment
		tags.append([tag_name, tag_position])
		
		adjustment += end - start
		last_index = end
		
	final_text += cleaned_text.substr(last_index, cleaned_text.length() - last_index)
	
	return ParsedText.new(input_text, final_text, tags, used_variables)


static func publish_variable(key: String, variable):
	variables[key] = variable
