extends VBoxContainer


onready var top: Label = $Name
onready var disc: Label = $Panel/MarginContainer/Label


func _ready() -> void:
	top.text = Global.translate('#VIDEO_TOP')
	disc.text = Global.translate('#VIDEO_DISC')
