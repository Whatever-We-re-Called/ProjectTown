extends UIAction
class_name OnShow


func _ready():
	if not parent() is UIItem and parent().visible:
		execute()


func execute():
	start()
