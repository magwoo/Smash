extends ScaledButton


func _pressed() -> void:
	Global.add_balance(rand_range(0, 10000))
