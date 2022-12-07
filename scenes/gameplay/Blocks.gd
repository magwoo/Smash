extends Node2D


const spawn_timer: float = 3.0

onready var timer: Timer = Timer.new()

var block_packed: PackedScene = load('res://scenes/gameplay/Block.tscn')

var current_level: int = 1
var diff_level: int = 1

var bonus_arr: Array = [
	load('res://scenes/gameplay/bonuses/DamageBonus.tscn'),
	load('res://scenes/gameplay/bonuses/DoubleBonus.tscn'),
	load('res://scenes/gameplay/bonuses/SpeedBonus.tscn')
]


func _ready() -> void:
	diff_level = Global.upgrades[1] * 5
	self.add_child(timer)
	timer.start(spawn_timer)
	timer.connect('timeout', self, 'spawn_level')
	viewport_resized()
	Global.connect('viewport_resized', self, 'viewport_resized')


func spawn_level() -> void:
	if Global.is_tutorial: return
	var line_count: int = int(rand_range(3, 7.1))
	
	var line_health: Array = []
	var line_nodes: Array = []
	
	var line_hash: int = int(rand_range(0, 1000000000))
	var bonus_num: int = -1
	 
	if int(rand_range(0, 1.1 + Global.upgrades[3] / 100)):
		bonus_num = int(rand_range(0, line_count - 0.01))
	
	for i in line_count:
		var block: StaticBody2D = block_packed.instance()
		line_nodes.append(block)
		
		var temp_size: float = (684 - 15 * (line_count - 1)) / line_count
		block.size = Vector2(temp_size, temp_size)
		block.position = Vector2(i * 684 / line_count + block.size.x / 2 - 684 / 2, -220)
		
		block.health = int(rand_range(max(1, diff_level * 0.2), diff_level * 2.5))
		block.self_level = current_level
		block.level_hash = line_hash
		block.add_to_group(str(line_hash))
		
		if i == bonus_num: spawn_bonus(block)
		
		line_health.append(block.health)
	
	var max_health: int = line_health.max()
	var min_health: int = line_health.min()
	
	for block in line_nodes:
		block.line_max_heath = max_health
		block.line_min_heath = min_health
		self.add_child(block)
	
	current_level += 1


func spawn_bonus(block: StaticBody2D) -> void:
	var bonus: Sprite = bonus_arr[int(rand_range(0, bonus_arr.size() - 0.01))].instance()
	bonus.global_position = Vector2(rand_range(-300, 300), -480)
	self.add_child(bonus)


func viewport_resized() -> void:
	self.position.x = get_viewport_rect().size.x / 2
