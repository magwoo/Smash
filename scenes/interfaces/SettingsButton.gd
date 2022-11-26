extends ScaledButton


onready var tree: Control = get_tree().current_scene
onready var settings_packed: PackedScene = load('res://scenes/interfaces/Settings.tscn')


func _pressed() -> void:
	var settings_scene: CanvasLayer = settings_packed.instance()
	tree.add_child(settings_scene)
