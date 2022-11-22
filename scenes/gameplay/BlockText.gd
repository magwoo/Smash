extends Label


var target_scale: float = 1.0


func _ready() -> void:
	self.rect_pivot_offset = self.rect_size / 2


func _process(_delta: float) -> void:
	target_scale = lerp(target_scale, 1, Global.lerp_index)
	self.rect_scale = Vector2(target_scale, target_scale)
