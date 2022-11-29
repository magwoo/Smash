extends 'res://scenes/interfaces/SettingsButtonClass.gd'


var icons: Array = [
	load('res://resources/images/EffectsOffIcon.svg'),
	load('res://resources/images/EffectsIcon.svg')
]


func _ready() -> void:
	self.icon = icons[int(Global.effects)]


func _pressed() -> void:
	Global.effects = !Global.effects
	SDK.set_bool_data('Effects', Global.effects, true)
	self.icon = icons[int(Global.effects)]
