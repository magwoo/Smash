extends ScaledButton


onready var tree: Control = $'../../../../../..'
onready var settings_packed: PackedScene = load('res://scenes/interfaces/Settings.tscn')


func _pressed() -> void:
	tree.is_blured = true
	
	var settings_scene: CanvasLayer = settings_packed.instance()
	tree.add_child(settings_scene)
