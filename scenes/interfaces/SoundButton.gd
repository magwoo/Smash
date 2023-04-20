extends "res://scenes/interfaces/SettingsButtonClass.gd"


var icons: Array = [
	load('res://resources/images/SoundOffIcon.svg'),
	load('res://resources/images/SoundIcon.svg')
]


func _ready() -> void:
	self.icon = icons[int(Global.sounds)]


func _pressed() -> void:
	Global.sounds = !Global.sounds
	SDK.player.set_data('Sounds', Global.sounds, true)
	self.icon = icons[int(Global.sounds)]
