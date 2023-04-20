extends 'res://scenes/interfaces/SettingsButtonClass.gd'


var lang_icons: Array = [
	load('res://resources/images/LanguageIcon.svg'),
	load('res://resources/images/ENLangIcon.svg')
]


func _ready() -> void:
	self.icon = lang_icons[Global.lang]


func _pressed() -> void:
	if Global.lang:
		TranslationServer.set_locale('ru')
		Global.lang = 0
		self.icon = lang_icons[Global.lang]
	else:
		TranslationServer.set_locale('en')
		Global.lang = 1
		self.icon = lang_icons[Global.lang]

	SDK.player.set_data('Lang', Global.lang, true)
