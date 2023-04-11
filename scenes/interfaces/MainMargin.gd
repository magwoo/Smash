extends MarginContainer


func _ready() -> void:
	self.modulate.a = 0.0


func _process(_delta: float) -> void:
	if Global.is_game:
		self.modulate.a = lerp(self.modulate.a, 0.0, Global.lerp_index)
	else:
		self.modulate.a = lerp(self.modulate.a, 1.0, Global.lerp_index)


func _input(event: InputEvent) -> void:
	if Input.is_action_just_released('mouse_left') && Global.sounds:
		play_sound()

	if event is InputEventScreenTouch:
		if !event.pressed && Global.sounds: play_sound()


func play_sound() -> void:
	var player: AudioStreamPlayer = AudioStreamPlayer.new()
	player.connect('finished', self, '_remove_player', [player])
	player.stream = Global.sound_packets.tap
	player.volume_db = -10.0
	self.add_child(player)
	player.play()

func _remove_player(player: AudioStreamPlayer) -> void:
	player.queue_free()
