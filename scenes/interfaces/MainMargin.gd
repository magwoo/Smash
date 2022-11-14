extends MarginContainer


func _ready() -> void:
	self.modulate.a = 0


func _process(_delta: float) -> void:
	if Global.is_game:
		self.modulate.a = lerp(self.modulate.a, 0, Global.lerp_index)
	else:
		self.modulate.a = lerp(self.modulate.a, 1, Global.lerp_index)
