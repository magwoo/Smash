extends MarginContainer


var buttons: Array = []


func _ready() -> void:
	for i in $UpgradeGrid.get_child_count():
		buttons.append($UpgradeGrid.get_child(i))


func _process(_delta: float) -> void:
	pass
