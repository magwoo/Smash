extends Label


func _ready() -> void:
	_high_score_changed(Global.high_score)
	Global.connect('high_score_changed', self, '_high_score_changed')


func _high_score_changed(value: int) -> void:
	self.text = Global.cut_number(value)
