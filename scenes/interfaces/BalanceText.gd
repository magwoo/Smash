extends Label


var target_number: float
var current_number: float


func _ready() -> void:
	_balance_changed(Global.balance)
	Global.connect('balance_changed', self, '_balance_changed')


func _process(_delta: float) -> void:
	current_number = lerp(current_number, target_number + 0.9, Global.lerp_index)
	self.text = Global.cut_number(int(current_number))


func _balance_changed(value: int) -> void:
	target_number = value
