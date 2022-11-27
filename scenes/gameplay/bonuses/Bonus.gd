extends Sprite


onready var area: Area2D = $Area2D


func _ready() -> void:
	area.connect('area_entered', self, '_collect')


func _process(_delta: float) -> void:
	var temp_scale: float = 1 + Global.asint / 5
	self.scale = Vector2(temp_scale, temp_scale)


func _collect(area: Area2D) -> void:
	if area.is_in_group('Player'):
		self.queue_free()
