extends KinematicBody2D


var target_position: Vector2 = Vector2()
var shoot_speed: float = 1.0
var target_angle: float = 0

var bullet_packed: PackedScene = load('res://scenes/gameplay/Bullet.tscn')

onready var sprite: Sprite = $Sprite
onready var area: Area2D = $PlayerArea
onready var bullets_node: Node2D = $'../Bullets'

var timer: Timer

onready var viewport: Vector2 = get_viewport_rect().size
onready var size: Vector2 = sprite.texture.get_size() * sprite.scale


func _ready() -> void:
	shoot_speed = 0.4 / Global.upgrades[1]
	self.position = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y - 202)
	area.connect('area_entered', self, 'area_entered')
	Global.connect('viewport_resized', self, 'viewport_resized')
	timer = Timer.new()
	self.add_child(timer)
	timer.connect('timeout', self, 'shoot')
	timer.start(shoot_speed)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion && Input.is_action_pressed('mouse_left'):
		target_position = event.relative
	
	if event is InputEventScreenDrag:
		target_position = event.relative


func _process(_delta: float) -> void:
	target_angle = target_position.x / 35
	self.move_and_slide(target_position * (1 / _delta))
	self.rotation = lerp(self.rotation, target_angle, Global.lerp_index)
	target_position = Vector2()
	
	self.position.x = clamp(self.position.x, viewport.x / 2 -360 + size.x / 2, viewport.x / 2 + 360 - size.x / 2)
	self.position.y = clamp(self.position.y, viewport.y / 1.5, viewport.y - size.y / 2)


func viewport_resized() -> void:
	viewport = get_viewport_rect().size


func shoot() -> void:
	var bullet: Sprite = bullet_packed.instance()
	bullet.damage = Global.upgrades[0]
	bullet.position = Vector2(self.position.x ,self.position.y - size.y / 2.5)
	bullet.ang = self.rotation
	bullets_node.add_child(bullet)


func area_entered(area: Area2D) -> void:
	if area.is_in_group('Block'):
		var tree: Node2D = $'..'
		
		if tree.scores > Global.high_score:
			Global.set_high_score(tree.scores, true)
		Global.add_balance(tree.scores, true)
		
		SDK.show_fullscreen_ad()
		
		Global.is_game = false
		self.queue_free()
