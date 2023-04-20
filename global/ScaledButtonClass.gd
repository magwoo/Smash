extends Button
class_name ScaledButton


export(float, 0.5, 1.5, 0.025) var focus_scale: float = 1.075
export(float, 0.5, 1.5, 0.025) var press_scale: float = 0.85
export(float, 0.0, 30.0, 0.5) var angle_mult: float = 5.0
export(float, 0.5, 1.5, 0.025) var anim_speed: float = 1.0

var target_scale: Vector2 = Vector2(1.0, 1.0)
var focused: bool = false
var touched: bool = false

var tween: Tween = Tween.new()


func _ready() -> void:
	self.connect('resized', self, '_resized')
	self.connect('mouse_entered', self, '_focused')
	self.connect('mouse_exited', self, '_unfocused')
	self.connect('button_down', self, '_button_down')
	self.connect('button_up', self, '_unpressed')

	tween.name = 'TweenAnimator'
	self.add_child(tween)

	self.rect_pivot_offset = self.rect_size / 2
	self.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if !event.pressed:
			animate_scale(Vector2(1.0, 1.0))
			focused = false


func animate_scale(target_scale: Vector2) -> void:
	tween.interpolate_property(
		self, 'rect_scale', self.rect_scale, target_scale, 0.125,
		Tween.TRANS_BACK, Tween.EASE_OUT
	)
	tween.start()


func animate_angle(target_angle: float = 0.0) -> void:
	tween.interpolate_property(
		self, 'rect_rotation', self.rect_rotation, target_angle, 0.125,
		Tween.TRANS_BACK, Tween.EASE_OUT
	)
	tween.start()


func _button_down() -> void:
	animate_scale(Vector2(press_scale, press_scale))


func _unpressed() -> void:
	if focused: _focused()
	else: animate_scale(Vector2(1.0, 1.0))


func _focused() -> void:
	animate_angle(rand_range(-angle_mult, angle_mult))
	animate_scale(Vector2(focus_scale, focus_scale))
	focused = true


func _unfocused() -> void:
	animate_angle(0.0)
	animate_scale(Vector2(1.0, 1.0))
	focused = false


func _resized() -> void:
	self.rect_pivot_offset = self.rect_size / 2.0
