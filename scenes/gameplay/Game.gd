extends Node2D


onready var label: Label = $CanvasLayer/Control/MarginContainer/Label
onready var player: KinematicBody2D = $Player

var menu_scene: PackedScene = load('res://scenes/interfaces/Main.tscn')

var scores: int = 0


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	if !Global.is_game:
		self.modulate.a = lerp(self.modulate.a, 0, Global.lerp_index)
		if self.modulate.a <= 0.00025: get_tree().change_scene_to(menu_scene)
