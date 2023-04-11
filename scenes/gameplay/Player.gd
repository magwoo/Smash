extends KinematicBody2D


var target_position: Vector2 = Vector2()
var shoot_speed: float = 1.0
var target_angle: float = 0.0
var _in_yield: bool = false

var double_bonus: float = 0.0
var speed_bonus: float = 0.0
var damage_bonus: float = 0.0

onready var sprite: Sprite = $Sprite
onready var area: Area2D = $PlayerArea
onready var bullets_node: Node2D = $'../Bullets'

var timer: Timer

onready var viewport: Vector2 = get_viewport_rect().size
onready var size: Vector2 = sprite.texture.get_size() * sprite.scale


func _ready() -> void:
	sprite.texture = Global.player_dic[Global.selected_player].image
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
	target_angle = target_position.x / 35.0
	self.move_and_slide(target_position * (1.0 / _delta))
	self.rotation = lerp(self.rotation, target_angle, Global.lerp_index)
	target_position = Vector2()

	double_bonus = max(0, double_bonus - _delta)
	damage_bonus = max(0, damage_bonus - _delta)
	speed_bonus = max(0, speed_bonus - _delta)

	self.position.x = clamp(
		self.position.x, viewport.x / 2.0 -360 + size.x / 2.0, viewport.x / 2.0 + 360 - size.x / 2.0
	)
	self.position.y = clamp(
		self.position.y, viewport.y / 1.5, viewport.y - size.y / 2.0
	)


func viewport_resized() -> void:
	viewport = get_viewport_rect().size


func shoot(doubled: bool = false) -> void:
	if !Global.is_game || Global.is_tutorial: return
	if double_bonus == 0:
		var bullet: Sprite = Pool.get_bullet()
		bullet.damage = Global.upgrades[0]
		if damage_bonus > 0: bullet.damage *= 2
		bullet.position = Vector2(self.position.x ,self.position.y - size.y / 2.5)
		bullet.ang = self.rotation
		bullets_node.add_child(bullet)
	else:
		for i in 2:
			var bullet: Sprite = Pool.get_bullet()
			bullet.damage = Global.upgrades[0]
			if damage_bonus > 0: bullet.damage *= 2
			bullet.position = Vector2(self.position.x ,self.position.y - size.y / 2.5)
			if i == 0:
				bullet.ang = self.rotation - 0.2
			else:
				bullet.ang = self.rotation + 0.2
			bullets_node.add_child(bullet)

	if speed_bonus > 0 && !doubled:
		_in_yield = true
		yield(get_tree().create_timer(shoot_speed / 2), 'timeout')
		_in_yield = false
		if Global.is_game:
			shoot(true)


func area_entered(area: Area2D) -> void:
	if area.is_in_group('Block'):
		var tree: Node2D = $'..'

		if tree.scores > Global.high_score:
			Global.set_high_score(tree.scores, true)
		Global.add_balance(tree.scores, true)

		SDK.show_fullscreen_ad()

		Global.is_game = false
		self.visible = false

		while _in_yield: yield(get_tree().create_timer(0.05), 'timeout')
		self.queue_free()
