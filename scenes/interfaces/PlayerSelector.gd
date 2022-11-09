extends HBoxContainer


onready var player: TextureRect = $PlayerPreview
onready var previus_button: ScaledButton = $PreviusButton
onready var next_button: ScaledButton = $NextButton

var player_init_angle: float = 0
var player_target_angle: float = 0

var select_player: int = 0


func _ready() -> void:
	previus_button.connect('pressed', self, '_previus_player')
	next_button.connect('pressed', self, '_next_player')
	player.rect_pivot_offset = player.rect_size / 2


func _process(_delta: float) -> void:
	player_init_angle = sin(Global.time) * 4
	var target_scale: float = 1 + sin(Global.time / 2) / 20
	player.rect_scale = Vector2(target_scale, target_scale)
	player_target_angle = lerp(player_target_angle, player_init_angle, Global.lerp_index)
	player.rect_rotation = lerp(player.rect_rotation, player_target_angle, Global.lerp_index)


func _previus_player() -> void:
	player_target_angle -= 25


func _next_player() -> void:
	player_target_angle += 25
