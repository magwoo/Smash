extends "res://scenes/gameplay/bonuses/Bonus.gd"


const bonus_time: float = 5.0


func collect() -> void:
	player.double_bonus += bonus_time + Global.upgrades[2] / 5
