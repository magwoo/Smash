extends Control


onready var blur: WorldEnvironment = $Blur
onready var menu_canvas: CanvasLayer = $MainMenu
onready var menu_tree: MarginContainer = $MainMenu/MainMargin
onready var settings_canvas: CanvasLayer = $Settings
onready var settings_node: Control = $Settings/Control

var is_blured: bool = false


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	var blur_value: float = blur.environment.dof_blur_near_amount
	
	if is_blured:
		settings_node.modulate.a = lerp(settings_node.modulate.a, 1, Global.lerp_index)
		blur_value = lerp(blur_value, 0.25, Global.lerp_index)
	else:
		settings_node.modulate.a = lerp(settings_node.modulate.a, 0, Global.lerp_index)
		blur_value = lerp(blur_value, 0, Global.lerp_index)
	
	blur.environment.dof_blur_near_amount = blur_value
