extends Sprite


var speed: float = 250

onready var area: Area2D = $Area2D
onready var player: KinematicBody2D = get_tree().get_nodes_in_group('PlayerNode')[0]


func _ready() -> void:
	area.connect('area_entered', self, '_collect')


func _process(_delta: float) -> void:
	self.position.y += speed * _delta
	var temp_scale: float = 1 + Global.asint / 5
	self.scale = Vector2(temp_scale, temp_scale)


func _collect(area: Area2D) -> void:
	if area.is_in_group('Player'):
		self.call('collect')
		self.queue_free()
