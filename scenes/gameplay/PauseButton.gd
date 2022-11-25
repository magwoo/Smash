extends ScaledButton


var settings_packed: PackedScene = load('res://scenes/interfaces/Settings.tscn')
onready var tree: Node2D = $'../../../..'
onready var canvas: CanvasLayer = $'../../..'


func _pressed() -> void:
	var settings_instance: CanvasLayer = settings_packed.instance()
	canvas.add_child(settings_instance)
	get_tree().paused = true
