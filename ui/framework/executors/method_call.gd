extends UIExecutor
class_name MethodCall


@export var object: Node
@export var method_name: String
@export var args: Array


func execute():
	if object == null:
		object = parent()
	
	var callable = Callable(object, method_name)
	if callable.is_valid():
		if args == null or args.size() == 0:
			callable.call()
		else:
			callable.callv(args)
	else:
		printerr("Callable is not valid")
