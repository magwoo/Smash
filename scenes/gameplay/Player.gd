extends KinematicBody2D


var target_position: Vector2 = Vector2()

onready var viewport: Vector2 = get_viewport_rect().size
onready var sprite: Sprite = $Sprite
onready var size: Vector2 = sprite.texture.get_size() * sprite.scale


func _ready() -> void:
	self.position = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y - 202)
	target_position = self.position


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion && Input.is_action_pressed('mouse_left'):
		target_position += event.relative


func _process(_delta: float) -> void:
	self.position = lerp(self.position, target_position, Global.lerp_index)
	self.position.x = clamp(self.position.x, size.x / 2, viewport.x - size.x / 2)
	self.position.y = clamp(self.position.y, viewport.y - 320, viewport.y - size.y / 2)
