extends CPUParticles2D


var time: float


func _process(_delta: float) -> void:
	time += _delta
	if time > self.lifetime:
		self.queue_free()
