extends Viewport


func _ready() -> void:
	var container: ViewportContainer = self.get_parent()
	container.connect('resized', self, 'resize')


func resize() -> void:
	self.size = get_viewport().size
