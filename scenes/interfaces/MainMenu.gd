extends Control


onready var blur: WorldEnvironment = $Blur
onready var menu_canvas: CanvasLayer = $MainMenu
onready var menu_tree: MarginContainer = $MainMenu/MainMargin

var is_blured: bool = false


func _ready() -> void:
	$Settings.queue_free()
	
	if OS.has_feature('HTML5'): blur.queue_free()


func _process(_delta: float) -> void:
	var blur_value: float = blur.environment.dof_blur_near_amount
	
	if is_blured:
		blur_value = lerp(blur_value, 0.25, Global.lerp_index)
	else:
		blur_value = lerp(blur_value, 0, Global.lerp_index)
	
	blur.environment.dof_blur_near_amount = blur_value
