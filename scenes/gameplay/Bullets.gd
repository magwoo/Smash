extends Node2D


func remove_player(player: AudioStreamPlayer) -> void:
	player.queue_free()
