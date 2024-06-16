extends Resource
class_name ConversationPiece


@export var speaker: Constants.Character = Constants.Character.PLAYER
@export_multiline var text: String

@export_group("Responses")
@export var response_options: Array[ResponseOption]

@export_group("Settings")
@export var position_override: DialogueManager.DialoguePosition
## Should the dialogue auto-calculate how long it takes to type out the message[br]
## [br]
## Dialogues with a value of true will appear to type at the same rate.
## Longer dialogues will take longer to type out fully,
## but the rate at which it types will be the same
@export var auto_calculate: bool = true
## How long should the dialogue take to type out the entire message[br]
## [br]
## Auto-Calculate must be set to false for this value to have any affect[br]
## [br]
## Value is the amount of seconds
@export var timing_override: float = 5
## Should the dialogue automatically continue to the next queued dialogue[br]
## [br]
## A value of false will require user input before continuing
@export var auto_continue: bool = true
## How long should the dialogue 'linger' before auto-continuing on to the next queued dialogue[br]
## [br]
## Auto-Continue must be set to true for this value to have any affect[br]
## [br]
## Value is the amount of seconds
@export var linger_time: float = 3
