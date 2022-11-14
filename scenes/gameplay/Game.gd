extends Node2D


onready var player: KinematicBody2D = $Player


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	if !Global.is_game:
		self.modulate.a = lerp(self.modulate.a, 0, Global.lerp_index)
		if self.modulate.a <= 0.1:
			get_tree().change_scene('res://scenes/interfaces/Main.tscn')
