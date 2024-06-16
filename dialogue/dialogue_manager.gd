extends Node


@onready var global_dialogues_list = load("res://dialogue/global_dialogues.tres").get_all_dialogues()
@onready var all_dialogues_list = load("res://dialogue/all_dialogues.tres").get_all_dialogues()

var dialogue_queue = []
var current_dialogues = []

var global_dialogues = {}
var character_dialogues = {}
var conversations = {}

func _ready():
	add_child(DialogueExecutor.new())
	
	_load_global_dialogues()
	_load_player_dialogues()
	_load_conversations()


func queue_raw(dialogue_instance: DialogueInstance):
	dialogue_queue.append(dialogue_instance)


func queue(key: String, position: DialoguePosition = DialoguePosition.MIDDLE):
	var speaker = key.split(".")[0]
	
	var dialogue_instances = []
	match speaker:
		"conversation": dialogue_instances = _get_conversation(key)
		_: dialogue_instances = _get_character_dialogue(key)
		
	if dialogue_instances == null or dialogue_instances.size() == 0:
		return
		
	for dialogue_instance in dialogue_instances:
		if not dialogue_instance.position:
			dialogue_instance.position = position
	
	dialogue_queue.append_array(dialogue_instances)
	
	
func _get_conversation(key):
	var conversation = conversations[key]
	if not conversation:
		return null
		
	var array = []
	for piece in conversation.pieces:
		var speaker = _find_speaker_in_tree(piece.speaker)
		if not speaker:
			print("Unable to find character in scene: ", speaker)
			continue
			
		var dialogue_instance = DialogueInstance.new(piece.text, speaker, piece.response_options,
							piece.auto_calculate, piece.timing_override,
							piece.auto_continue, piece.linger_time)
							
		
		if piece.position_override and piece.position_override != DialoguePosition.UNSET:
			dialogue_instance.position = piece.position_override
		
		array.append(dialogue_instance)
	
	return array
	
	
func _find_speaker_in_tree(speaker: Constants.Character) -> Node3D:
	var nodes = get_tree().get_nodes_in_group("dialogue_characters")
	for node in nodes:
		var character_info
		for child in node.get_children():
			if child is CharacterInfo:
				character_info = child
				break
		
		if character_info and character_info.character_enum == speaker:
			return node
			
	return null
	
	
func _get_character_dialogue(key: String, speaker: Constants.Character = -1):
	if key == null or key == "":
		return null
		
	if speaker == -1:
		var character
		for i in Constants.Character.keys().size():
			if Constants.Character.keys()[i] == key.split(".")[0].to_upper():
				character = i
		if character == null:
			print("Unknown dialogue character: ", key.split(".")[0].to_upper())
			return null
		speaker = character
	
	var is_global = key.split(".")[1] == "global"
	
	var dialogue = global_dialogues[key.substr(key.find(".") + 1)] if is_global else character_dialogues[key]
	if not dialogue:
		print("Dialogue not found: ", key)
		return null
	
	var speaker_node = _find_speaker_in_tree(speaker)
	if not speaker_node:
		print("Unable to find character in scene: ", speaker)
		return null
	
	var dialogue_instance = DialogueInstance.new(dialogue.text, speaker_node, [],
							dialogue.auto_calculate, dialogue.timing_override,
							dialogue.auto_continue, dialogue.linger_time)
	
	if dialogue.position_override and dialogue.position_override != DialoguePosition.UNSET:
		dialogue_instance.position = dialogue.position_override
	
	var array = [dialogue_instance]
	
	var next = _get_character_dialogue(dialogue.next_key)
	if next and not next.is_empty():
		dialogue_instance.next = next[0]
		next[0].previous = dialogue_instance
		
	return array


enum DialoguePosition {
	UNSET,
	LEFT,
	MIDDLE,
	RIGHT
}


func _load_global_dialogues():
	for dialogue in global_dialogues_list:
		if not dialogue.key.begins_with("global."):
			dialogue.key = "global." + dialogue.key
		global_dialogues[dialogue.key] = dialogue
		
		
func _load_player_dialogues():
	for dialogue in all_dialogues_list:
		character_dialogues[dialogue.key] = dialogue


func _load_conversations(path = "res://dialogue/conversations"):
	var dir = DirAccess.open(path)
	if not dir:
		print("Failed to open directory: ", path)
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if file_name == "." or file_name == "..":
			file_name = dir.get_next()
			continue

		var full_path = path + "/" + file_name
		if dir.current_is_dir():
			_load_conversations(full_path)
		else:
			if file_name.ends_with(".tres"):
				var resource = ResourceLoader.load(full_path)
				if resource is Conversation:
					conversations[resource.key] = resource
		file_name = dir.get_next()
	dir.list_dir_end()
