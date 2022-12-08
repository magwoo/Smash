extends Sprite


const speed: float = 1200.0

onready var area: Area2D = $Area2D
onready var notifier: VisibilityNotifier2D = $VisibilityNotifier2D

var root: Node2D
var dir: Vector2 = Vector2()
var ang: float = 0
var damage: int = 10

const recoil: float = 0.075


func _ready() -> void:
	area.connect('area_entered', self, 'area_entered')
	notifier.connect('screen_exited', self, 'destroy')

func _enter_tree() -> void:
	root = get_tree().current_scene
	ang += rand_range(-recoil, recoil)
	dir = Vector2(0, 1).rotated(ang)
	

func _process(_delta: float) -> void:
	var vel: Vector2 = dir * speed
	self.position -= vel * _delta


func area_entered(area: Area2D) -> void:
	if area.is_in_group('Block'):
		if Global.sounds:
			var player: AudioStreamPlayer = AudioStreamPlayer.new()
			player.connect('finished', self.get_parent(), 'remove_player', [player])
			player.stream = Global.sound_packets.shoot
			player.volume_db = -15
			root.add_child(player)
			player.play()
		if Global.is_game:
			root.scores += min(area.get_parent().health, damage)
			root.label.scores_changed()
		area.get_parent().hit(damage)
		destroy()


func destroy() -> void:
	Pool.return_bullet(self)
