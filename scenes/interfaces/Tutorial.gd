extends Node2D


onready var animator: AnimationPlayer = $AnimationPlayer

var destroyed: bool = false


func _init() -> void:
	self.modulate.a = 0


func _process(_delta: float) -> void:
	if !destroyed:
		self.modulate.a = min(self.modulate.a + 1 * _delta, 1)
	else:
		self.modulate.a -= 2 * _delta
		if self.modulate.a <= 0:
			self.queue_free()
	destroyed = !Global.is_tutorial
	
