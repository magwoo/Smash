extends 'res://scenes/interfaces/SettingsButtonClass.gd'


func _pressed() -> void:
	if OS.has_feature('editor'):
		Global.add_balance(10000, true)
		return
	SDK.open_leaderboard('Balance', 25)
