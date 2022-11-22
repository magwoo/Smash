extends StaticBody2D


var speed: float = 250

onready var viewport: Vector2 = get_viewport_rect().size
onready var label: Label = $Label

var health: int = 0


func _ready() -> void:
	health = rand_range(1, 400)
	label.text = Global.cut_number(health)


func hit(damage: int) -> void:
	health -= damage
	label.text = Global.cut_number(health)
	if health <= 0:
		self.queue_free()


func _process(_delta: float) -> void:
	self.position.y += speed * _delta 
	if self.position.y > viewport.y + 120:
		self.queue_free()
