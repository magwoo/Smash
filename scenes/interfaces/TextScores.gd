extends Label


onready var root: Node2D = $'/root/Game'

var target_scale: float


func _ready() -> void:
	self.connect('resized', self, 'resized')


func _process(_delta: float) -> void:
	target_scale = lerp(target_scale, 1, Global.lerp_index)
	self.rect_scale = Vector2(target_scale, target_scale)


func scores_changed() -> void:
	self.text = Global.cut_number(root.scores)
	target_scale += 0.25


func resized() -> void:
	self.rect_pivot_offset = self.rect_size / 2
