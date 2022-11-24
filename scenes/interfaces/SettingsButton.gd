extends ScaledButton


onready var settings: Control = $'../../../../../..'


func _pressed() -> void:
	settings.is_blured = !settings.is_blured
