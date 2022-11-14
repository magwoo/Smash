extends Sprite


var player_icon: TextureRect

var init_angle: float = 0
var target_angle: float = 0
var target_position: Vector2 = Vector2()
var target_scale: float = 0


func _ready() -> void:
	player_icon = get_tree().get_nodes_in_group('player_icon')[0]


func _process(_delta: float) -> void:
	if Global.is_game:
		target_position = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y - 200)
		target_scale = 0.35
		target_angle = 0
		if self.global_position.y > get_viewport_rect().size.y - 202:
			get_tree().change_scene('res://scenes/gameplay/Game.tscn')
	else:
		target_position = player_icon.rect_global_position + player_icon.rect_pivot_offset
		target_scale = 1 + sin(Global.time / 2) / 20
		init_angle = sin(Global.time) * 4
		target_angle = lerp(target_angle, init_angle, Global.lerp_index)
	
	var target_scale_vec: Vector2 = Vector2(target_scale, target_scale)
	
	self.rotation_degrees = lerp(self.rotation_degrees, target_angle, Global.lerp_index)
	self.scale = lerp(self.scale, target_scale_vec, Global.lerp_index)
	self.global_position = lerp(self.global_position ,target_position, Global.lerp_index)
	
	
