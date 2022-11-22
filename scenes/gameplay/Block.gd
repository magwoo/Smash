extends StaticBody2D


var speed: float = 250

onready var viewport: Vector2 = get_viewport_rect().size
onready var label: Label = $Label
onready var area: Area2D = $BlockArea
onready var collision: CollisionShape2D = $CollisionShape2D

var health: int = 0
var destroyed: bool = false
var line_max_heath: int = 0
var line_min_heath: int = 0


func _ready() -> void:
	label.text = Global.cut_number(health)


func hit(damage: int) -> void:
	health -= damage
	label.text = Global.cut_number(max(0, health))
	label.target_scale -= 0.1
	
	if health <= 0:
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
