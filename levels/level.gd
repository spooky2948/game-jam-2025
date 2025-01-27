extends Node
class_name Level

signal change_level(level_name: String)

func _ready():
	for i: LevelEnd in get_tree().get_nodes_in_group("LevelEnd"):
		i.change_level.connect(change_level.emit)
