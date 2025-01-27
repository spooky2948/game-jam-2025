extends Node

@export var first_level: PackedScene
var current_level: Level

func _ready():
	change_level(first_level)

func get_level_from_string(level: String):
	return load("res://levels/" + level + ".tscn")

func change_level(new_level: PackedScene):
	if (current_level):
		current_level.queue_free()
	current_level = new_level.instantiate()
	current_level.change_level.connect(_on_player_end_level)
	add_child.call_deferred(current_level)

func _on_player_end_level(new_level: String):
	change_level(get_level_from_string(new_level))
