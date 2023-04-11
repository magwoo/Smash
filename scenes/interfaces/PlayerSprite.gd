extends Sprite


var player_icon: TextureRect

var init_angle: float = 0.0
var target_angle: float = 0.0
var target_position: Vector2 = Vector2(0.0, 0.0)
var target_scale: float = 0.0

var game_scene: PackedScene = load('res://scenes/gameplay/Game.tscn')


func _ready() -> void:
	player_icon = get_tree().get_nodes_in_group('player_icon')[0]
	self.global_position = player_icon.rect_global_position + player_icon.rect_pivot_offset


func _process(_delta: float) -> void:
	if Global.is_game:
		target_position = Vector2(
			get_viewport_rect().size.x / 2.0, get_viewport_rect().size.y - 200.0
		)
		target_scale = 0.35
		target_angle = 0.0
		if self.global_position.y > get_viewport_rect().size.y - 202.0:
			get_tree().change_scene_to(game_scene)
	else:
		target_position = player_icon.rect_global_position + player_icon.rect_pivot_offset
		target_scale = 1.0 + sin(Global.time / 2.0) / 20.0
		init_angle = sin(Global.time) * 4.0
		target_angle = lerp(target_angle, init_angle, Global.lerp_index)

	var target_scale_vec: Vector2 = Vector2(target_scale, target_scale)

	self.rotation_degrees = lerp(self.rotation_degrees, target_angle, Global.lerp_index)
	self.scale = lerp(self.scale, target_scale_vec, Global.lerp_index)
	self.global_position = lerp(self.global_position ,target_position, Global.lerp_index)


