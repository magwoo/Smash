extends ScaledButton


func _button_pressed() -> void:
	Global.add_balance(rand_range(0, 10060))
	Global.set_high_score(rand_range(0, 1000))
