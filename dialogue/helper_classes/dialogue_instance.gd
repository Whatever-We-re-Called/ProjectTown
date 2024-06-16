extends Node
class_name DialogueInstance


var parsed_text: ParsedText
var character: Node3D
var position: DialogueManager.DialoguePosition

var response_options: Array[ResponseOption]

var auto_calculate: bool
var timing_override: float
var auto_continue: bool
var linger_time: float

var next: DialogueInstance = null
var previous: DialogueInstance = null
var scene = null
var complete = false


func _init(unparsed_text: String, character: Node3D,
		response_options: Array[ResponseOption] = [],
		auto_calculate: bool = true, timing_override: float = 5,
		auto_continue: bool = true, linger_time: float = 3):
			
	self.parsed_text = TextParser.parse(unparsed_text)
	self.character = character
	self.response_options = response_options
	self.auto_calculate = auto_calculate
	self.timing_override = timing_override
	self.auto_continue = auto_continue and not UserSettings.require_input_for_dialogues
	self.linger_time = linger_time
