extends Control


onready var menu_canvas: CanvasLayer = $MainMenu
onready var menu_tree: MarginContainer = $MainMenu/MainMargin


func _ready() -> void:
	$Settings.queue_free()


func _process(_delta: float) -> void:
	pass
