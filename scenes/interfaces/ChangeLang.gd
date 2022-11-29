extends 'res://scenes/interfaces/SettingsButtonClass.gd'


var lang_icons: Array = [
	load('res://resources/images/LanguageIcon.svg'),
	load('res://resources/images/ENLangIcon.svg')
]


func _ready() -> void:
	self.icon = lang_icons[Global.lang]


func _pressed() -> void:
	if Global.lang:
		Global.lang = 0
	else:
		Global.lang = 1
	
	SDK.set_data('Lang', Global.lang)
	SDK.sync_data()
	
	get_tree().change_scene("res://scenes/interfaces/Main.tscn")
