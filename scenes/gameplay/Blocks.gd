extends Node2D


const spawn_timer: float = 3.0

onready var timer: Timer = Timer.new()

var block_packed: PackedScene = load('res://scenes/gameplay/Block.tscn')


func _ready() -> void:
	self.add_child(timer)
	timer.start(spawn_timer)
	timer.connect('timeout', self, 'spawn_level')
	viewport_resized()
	Global.connect('viewport_resized', self, 'viewport_resized')


func spawn_level() -> void:
	for i in 4:
		var block: StaticBody2D = block_packed.instance()
		block.position = Vector2(-262.5 + i * 175, -220)
		self.add_child(block)


func viewport_resized() -> void:
	self.position.x = get_viewport_rect().size.x / 2
