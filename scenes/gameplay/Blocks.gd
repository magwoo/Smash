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
	var line_health: Array = []
	var line_nodes: Array = []
	
	for i in 4:
		var block: StaticBody2D = block_packed.instance()
		line_nodes.push_front(block)
		block.position = Vector2(-262.5 + i * 175, -220)
		block.health = rand_range(1, 400)
		line_health.push_front(block.health)
		self.add_child(block)


func viewport_resized() -> void:
	self.position.x = get_viewport_rect().size.x / 2
