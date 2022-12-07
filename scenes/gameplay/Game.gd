extends Node2D


onready var label: Label = $CanvasLayer/Control/MarginContainer/Label
onready var player: KinematicBody2D = $Player

var menu_scene: PackedScene = load('res://scenes/interfaces/Main.tscn')
var tutorial_packed: PackedScene = load('res://scenes/interfaces/Tutorial.tscn')

var scores: int = 0

var tutorial_scene: Node2D

var touched: bool = false


func _ready() -> void:
	yield(get_tree().create_timer(0.5), 'timeout')
	if !touched:
		tutorial_scene = tutorial_packed.instance()
		tutorial_scene.position = get_viewport_rect().size / 2
		tutorial_scene.position.y += get_viewport_rect().size.y / 8
		self.add_child(tutorial_scene)


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed('mouse_left') || event is InputEventScreenDrag:
		Global.is_tutorial = false
		touched = true


func _process(_delta: float) -> void:
	if !Global.is_game:
		self.modulate.a = lerp(self.modulate.a, 0, Global.lerp_index)
		if self.modulate.a <= 0.00025: get_tree().change_scene_to(menu_scene)
