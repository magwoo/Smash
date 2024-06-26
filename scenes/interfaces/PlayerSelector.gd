extends HBoxContainer


onready var player: TextureRect = $PlayerPreview
onready var player_sprite: Sprite = get_tree().get_nodes_in_group('PlayerSprite')[0]
onready var previus_button: ScaledButton = $PreviusButton
onready var next_button: ScaledButton = $NextButton

var select_player: int = 1


func _ready() -> void:
	select_player = Global.selected_player
	player.rect_pivot_offset = player.rect_size / 2.0

	previus_button.connect('pressed', self, 'previus_skin')
	next_button.connect('pressed', self, 'next_skin')

	update_player()


func previus_skin() -> void:
	select_player = clamp(select_player - 1, 1, Global.player_dic.size())
	player_sprite.target_angle -= 65.0

	update_player()


func next_skin() -> void:
	select_player = clamp(select_player + 1, 1, Global.player_dic.size())
	player_sprite.target_angle += 65.0

	update_player()


func update_player() -> void:
	Global.selected_player = select_player
	player_sprite.texture = Global.player_dic[select_player].image
	player_sprite.scale -= Vector2(0.25, 0.25)
