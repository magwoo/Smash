extends Label


func _ready() -> void:
	_balance_changed(Global.balance)
	Global.connect('balance_changed', self, '_balance_changed')


func _balance_changed(value: int) -> void:
	self.text = str(value)
