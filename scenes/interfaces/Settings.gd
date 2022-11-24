extends CanvasLayer


onready var control: Control = $Control

var is_destroyed: bool = false


func _ready() -> void: 
	control.modulate.a = 0
	self.offset.y = -120


func _process(_delta: float) -> void:
	self.offset.y = lerp(self.offset.y, 0, Global.lerp_index)
	
	if is_destroyed:
		control.modulate.a -= 4 * _delta
		if control.modulate.a < 0:
			self.queue_free()
	else:
		control.modulate.a += 4 * _delta
		control.modulate.a = min(1, control.modulate.a)
