extends HBoxContainer


onready var player: TextureRect = $PlayerPreview
onready var previus_button: ScaledButton = $PreviusButton
onready var next_button: ScaledButton = $NextButton

var select_player: int = 0


func _ready() -> void:
	player.rect_pivot_offset = player.rect_size / 2
