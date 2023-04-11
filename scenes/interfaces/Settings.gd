extends CanvasLayer


const FADE_SPEED: float = 4.0

onready var control: Control = $Control

var is_destroyed: bool = false
var selected_button: Button

var tween: Tween = Tween.new()


func _ready() -> void:
	self.add_child(tween)
	control.modulate.a = 0

	tween.interpolate_property(
		self, 'offset', Vector2(0.0, -120.0), Vector2(0.0, 0.0),
		0.3, Tween.TRANS_BACK, Tween.EASE_OUT
	)
	tween.start()



func _process(_delta: float) -> void:
	if is_destroyed:
		control.modulate.a -= FADE_SPEED * _delta
		if control.modulate.a < 0.0: self.queue_free()
	else:
		control.modulate.a += FADE_SPEED * _delta
		control.modulate.a = min(1.0, control.modulate.a)
