extends 'res://scenes/interfaces/SettingsButtonClass.gd'


onready var tree_node: CanvasLayer = $'../../../..'


func _pressed() -> void:
	tree_node.is_destroyed = true
	get_tree().paused = false
