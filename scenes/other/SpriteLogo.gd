extends Sprite


var is_focused: bool = false
var target_scale: Vector2 = Vector2(1, 1)

var step: int = 0


func _ready() -> void:
	self.modulate.a = 0
	center()


func _input(event: InputEvent) -> void:
	if Input.is_action_just_released('mouse_left'):
		is_focused = false
	elif event is InputEventScreenTouch && !event.is_pressed():
		is_focused = false
	
	if event is InputEventMouseMotion && Input.is_action_pressed('mouse_left'):
		self.global_position += event.relative
		is_focused = true
	elif event is InputEventScreenDrag:
		self.global_position += event.relative
		is_focused = true


func _process(_delta: float) -> void:
	if is_focused:
		target_scale = lerp(target_scale, Vector2(0.8, 0.8), Global.lerp_index)
	else:
		target_scale = lerp(target_scale, Vector2(1, 1), Global.lerp_index)
	
	if step == 1:
		self.modulate.a = min(1, self.modulate.a + 1.5 * _delta)
	if step == 2:
		self.modulate.a = max(0, self.modulate.a - 2.5 * _delta)
	
	self.scale = target_scale


func center() -> void:
	self.global_position = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 3)
