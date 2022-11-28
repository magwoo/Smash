extends MarginContainer


var buttons: Array = []


func _ready() -> void:
	for i in $UpgradeGrid.get_child_count():
		var button = $UpgradeGrid.get_child(i)
		if Global.balance < button.buy_cost * pow(Global.upgrades[i], 2):
			buttons.append(button)
		else:
			if int(rand_range(0, 1.5)): button.video_avaible = true
	
	if !buttons.size(): return
	var temp_button = buttons[int(rand_range(0, buttons.size() - 0.01))]
	temp_button.video_avaible = true
	temp_button.update_all()


func _process(_delta: float) -> void:
	pass
