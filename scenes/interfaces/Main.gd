extends Control


onready var video_packed: PackedScene = load('res://scenes/interfaces/UpgradeVideo.tscn')


func _ready() -> void:
	Global.is_tutorial = true
