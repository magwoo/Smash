extends ScaledButton


onready var root: CanvasLayer = $'../../../../..'


func _pressed() -> void:
	root.is_destroyed = true
