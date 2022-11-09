extends ScaledButton


onready var bar: ProgressBar = $ProgressBar
onready var name_text: Label = $TextMargin/Name
onready var level_text: Label = $TextMargin/Level
onready var cost_text: Label = $TextMargin/Cost

export(int) var buy_cost: int = 0
export(int, 1, 4) var index: int = 1

var target_value: float = 0
var cost: int = 0


func _ready() -> void:
	_update_all()


func _process(_delta: float) -> void:
	_update_all()
	bar.value = lerp(bar.value, target_value, Global.lerp_index)


func _button_pressed() -> void:
	Global.upgrades[index - 1] += 1
	_update_all()


func _update_all() -> void:
	_update_bar()
	_update_text()
	_update_cost()


func _update_cost() -> void:
	cost = buy_cost * pow(Global.upgrades[index - 1], 2)
 

func _update_bar() -> void:
	bar.max_value = cost
	target_value = min(bar.max_value, Global.balance)


func _update_text() -> void:
	cost_text.text = Global.cut_number(cost)
	level_text.text = 'УРОВЕНЬ ' + str(Global.upgrades[index - 1])
