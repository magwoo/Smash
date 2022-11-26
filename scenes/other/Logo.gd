extends TextureRect
	

func _process(_delta: float) -> void:
	self.rect_pivot_offset = self.rect_size / 2
