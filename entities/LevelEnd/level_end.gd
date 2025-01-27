extends Area2D
class_name LevelEnd

#This *should* be a packed scene ideally but godot doesnt like cyclic scene references
#So if u have two levels which you can go between godot gives up and sets the reference to null instead
@export var new_level: String

signal change_level(level: String)

func _on_body_entered(body):
	if (body is Player):
		change_level.emit(new_level)
