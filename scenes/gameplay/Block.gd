extends StaticBody2D


var speed: float = 250

onready var viewport: Vector2 = get_viewport_rect().size
onready var spawner: Node2D = get_parent()
onready var label: Label = $Label
onready var area: Area2D = $BlockArea
onready var sprite: Sprite = $Sprite
onready var collision: CollisionShape2D = $CollisionShape2D

var health: int = 0
var destroyed: bool = false
var line_max_heath: int = 0
var line_min_heath: int = 0
var start_health: int = 0

var self_level: int = 0
var size: Vector2 = Vector2()


func _ready() -> void:
	self.scale = size / sprite.texture.get_size()
	
	label.text = Global.cut_number(health)
	
	sprite.modulate.r = min(0.925, 0.5 + self_level / 100.0)
	
	start_health = health
	
	update_color()


func update_color() -> void:
	var color_offest: float
	
	if !float(line_max_heath - line_min_heath) == 0:
		color_offest = float(health - line_min_heath) / float(line_max_heath - line_min_heath)
	else:
		line_max_heath += 2
	color_offest = 1 - color_offest
	sprite.modulate.g = clamp(0.65 * color_offest, 0.4, 0.75) 
	

func hit(damage: int) -> void:
	health -= damage
	label.text = Global.cut_number(max(0, health))
	label.target_scale -= 0.15
	update_color()
	
	if health <= 0:
		spawner.diff_level += int(max(1, start_health / 25.0))
		area.queue_free()
		collision.queue_free()
		destroyed = true


func _process(_delta: float) -> void:
	self.position.y += speed * _delta
	
	if destroyed:
		self.modulate.a -= 7.5 * _delta
		self.scale += Vector2(2.5 * _delta, 2.5 * _delta)
		if self.modulate.a < 0:
			self.queue_free()
		 
	if self.position.y > viewport.y + 120:
		self.queue_free()
