extends Resource
class_name GlobalDialogues


@export var dialogues: Array[Dialogue]


# Build in case we want to separate out global dialogues into folders or something later
func get_all_dialogues() -> Array[Dialogue]:
	var array: Array[Dialogue] = []
	array.append_array(dialogues)
	return array
