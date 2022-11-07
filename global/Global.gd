extends Node

signal high_score_changed
signal balance_changed


const lerp_speed: float = 0.25	#lerp speed

var timer: Timer

var lerp_index: float = 1.0
var time: float = 0.0
var asint: float = 0.0

var balance: int = 0
var high_score: int = 0

var cut_number_dic: Dictionary = {
	1: 'K',
	2: 'M',
	3: 'B'
}


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	time += _delta
	lerp_index = lerp_speed * _delta * 60
	asint = abs(sin(time))


static func get_lerp_speed() -> float:
	return 0.25


func reload_info() -> void:
	emit_signal('balance_changed')
	emit_signal('high_score_changed')


func set_balance(value: int) -> void:
	balance = max(0, value)
	emit_signal('balance_changed', balance)
	assert(value >= 0, 'set balance < 0')


func add_balance(amount: int) -> void:
	balance += max(0, amount)
	emit_signal('balance_changed', balance)
	assert(amount >= 0, 'add balance < 0')


func reduce_balance(amount: int) -> void:
	balance -= max(0, amount)
	emit_signal('balance_changed', balance)
	assert(amount >= 0, 'reduce balance < 0')


func set_high_score(value: int) -> void:
	high_score = max(0, value)
	emit_signal('high_score_changed', high_score)
	assert(value >= 0, 'set high score < 0')


func cut_number(number: float) -> String:
	return str(number)







