extends Button
class_name ScaledButton


export(float, 0.5, 1.5, 0.025) var focus_scale: float = 1.075
export(float, 0.5, 1.5, 0.025) var press_scale: float = 0.85
export(float, 0.5, 1.5, 0.025) var anim_speed: float = 1.0

var target_scale: Vector2 = Vector2(1.0, 1.0)
var focused: bool = false
var touched: bool = false


func _ready() -> void:
	self.connect('resized', self, '_resized')
	self.connect('mouse_entered', self, '_focused')
	self.connect('mouse_exited', self, '_unfocused')
	self.connect('button_down', self, '_button_down')
	self.connect('button_up', self, '_unpressed')
	self.rect_pivot_offset = self.rect_size / 2
	

func _process(_delta: float) -> void:
	if self.rect_scale.x != target_scale.x:
		self.rect_scale = lerp(self.rect_scale, target_scale, Global.lerp_index)


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if !event.pressed:
			target_scale = Vector2(1.0, 1.0)
			focused = false
			

func _button_down() -> void:
	target_scale = Vector2(press_scale, press_scale)
	

func _unpressed() -> void:
	if focused:
		target_scale = Vector2(focus_scale, focus_scale)
	else:
		target_scale = Vector2(1.0, 1.0)


func _focused() -> void:
	target_scale = Vector2(focus_scale, focus_scale)
	focused = true


func _unfocused() -> void:
	target_scale = Vector2(1.0, 1.0)
	focused = false


func _resized() -> void:
	self.rect_pivot_offset = self.rect_size / 2
	print('button resized')
