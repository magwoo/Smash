extends Sprite


const speed: float = 1200.0

onready var area: Area2D = $Area2D
onready var notifier: VisibilityNotifier2D = $VisibilityNotifier2D
onready var root: Node2D = self.get_parent().get_parent()

var dir: Vector2 = Vector2()
var ang: float = 0
var damage: int = 1440


func _ready() -> void:
	dir = Vector2(0, 1).rotated(ang)
	area.connect('area_entered', self, 'area_entered')
	notifier.connect('screen_exited', self, 'destroy')


func _process(_delta: float) -> void:
	var vel: Vector2 = dir * speed
	self.position -= vel * _delta


func area_entered(area: Area2D) -> void:
	if area.is_in_group('Block'):
		root.scores += min(area.get_parent().health, damage)
		root.label.scores_changed()
		area.get_parent().hit(damage)
		self.queue_free()


func destroy() -> void:
	self.queue_free()
