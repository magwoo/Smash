extends ScaledButton


export var lang_tag: String


func _ready() -> void:
	$MarginContainer/Label.text = Global.translate(lang_tag)
