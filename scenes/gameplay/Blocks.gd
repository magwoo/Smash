extends Node2D


const spawn_timer: float = 3.0

onready var timer: Timer = Timer.new()

var block_packed: PackedScene = load('res://scenes/gameplay/Block.tscn')

var current_level: int = 1


func _ready() -> void:
	self.add_child(timer)
	timer.start(spawn_timer)
	timer.connect('timeout', self, 'spawn_level')
	viewport_resized()
	Global.connect('viewport_resized', self, 'viewport_resized')


func spawn_level() -> void:
	var line_count: int = 4
	
	var line_health: Array = []
	var line_nodes: Array = []
	
	for i in line_count:
		var block: StaticBody2D = block_packed.instance()
		line_nodes.append(block)
		block.position = Vector2(-262.5 + i * 175, -220)
		block.health = rand_range(10, 4000)
		block.self_level = current_level
		line_health.append(block.health)
	
	var max_health: int = line_health.max()
	var min_health: int = line_health.min()
	
	for block in line_nodes:
		block.line_max_heath = max_health
		block.line_min_heath = min_health
		self.add_child(block)
	
	current_level += 1


func viewport_resized() -> void:
	self.position.x = get_viewport_rect().size.x / 2
