extends Node

signal high_score_changed
signal balance_changed
signal game_mode_changed
signal viewport_resized


const _lerp_speed: float = 0.25	#lerp speed

var buy_particle_packed: PackedScene = load('res://scenes/other/BuyParticles.tscn')

var lerp_index: float = 1.0
var time: float = 0.0
var asint: float = 0.0

var balance: int = 0
var high_score: int = 0

var selected_player: int = 1
var is_game: bool = false
var lang: int = 0
var sounds: bool = true
var effects: bool = true
var is_tutorial: bool = true

var upgrades: Array = [1, 1, 1, 1]

var cut_number_dic: Dictionary = {
	1: 'K',
	2: 'M',
	3: 'B',
	4: 'T',
	5: 'Q'
}

var player_dic: Dictionary = {
	1: {
		'image': load('res://resources/images/PlayerSkins/Player.svg'),
		'price': 1000,
		'has': true
	},
	2: {
		'image': load('res://resources/images/PlayerSkins/Player1.svg'),
		'price': 65000,
		'has': false
	},
	3: {
		'image': load('res://resources/images/PlayerSkins/Player2.svg'),
		'price': 550000,
		'has': false
	}
}

var _lang_dic: Dictionary = {
	'#PLAY': ['ИГРАТЬ', 'PLAY'],
	'#DAMAGE': ['УРОН', 'DAMAGE'],
	'#SHOOT_SPEED': ['ТЕМП СТРЕЛЬБЫ', 'SHOOT SPEED'],
	'#BONUS_TIME': ['ВРЕМЯ БОНУСА', 'BONUS TIME'],
	'#BONUS_CHANCE': ['ШАНС БОНУСА', 'BONUS CHANCE'],
	'#BUY': ['КУПИТЬ', 'BUY'],
	'#LEVEL': ['УРОВЕНЬ', 'LEVEL'],
	'#SOUND': ['ЗВУКИ', 'SOUNDS'],
	'#LANG': ['ЯЗЫК', 'LANG'],
	'#EFFECTS': ['ЭФФЕКТЫ', 'EFFECTS'],
	'#TOP': ['ТОП', 'TOP'],
	'#BACK': ['НАЗАД', 'BACK'],
	'#FREE': ['БЕСПЛАТНО', 'FREE'],
	'#VIDEO_TOP': ['ПРОКАЧКА ЗА ВИДЕО', 'PUMPING FOR VIDEO'],
	'#VIDEO_DISC': [
		'получи один уровень прокачки за просмотр видео рекламы',
		'get a level boost for watching video ads'
	]
}

var sound_packets: Dictionary = {
	'shoot': load('res://resources/sounds/ShootSound.wav'),
	'tap': load('res://resources/sounds/TapSound.wav')
}


func _ready() -> void:
	self.pause_mode = Node.PAUSE_MODE_PROCESS
	SDK.connect('cloud_ready', self, '_cloud_ready')
	randomize()


func translate(tag: String) -> String:
	assert(_lang_dic.has(tag), tag + ' missing')
	return _lang_dic[tag][lang]


func _cloud_ready() -> void:
	yield(get_tree().create_timer(0.05), 'timeout')

	if SDK.get_data('Lang') == -1:
		lang = SDK.get_language() != 'ru'
	else:
		lang = SDK.get_data('Lang')

	set_balance(SDK.get_data('Balance'))
	set_high_score(SDK.get_data('HighScore'))

	sounds = SDK.get_bool_data('Sounds')
	effects = SDK.get_bool_data('Effects')

	upgrades = [
		SDK.get_data('Upgrade1'),
		SDK.get_data('Upgrade2'),
		SDK.get_data('Upgrade3'),
		SDK.get_data('Upgrade4')
	]


func _process(_delta: float) -> void:
	time += _delta
	lerp_index = _lerp_speed * _delta * 60
	asint = sin(time)


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed('esc') && OS.has_feature('debug'):
		get_tree().quit()


static func get_lerp_speed() -> float:
	return 0.25


func reload_info() -> void:
	emit_signal('balance_changed', balance)
	emit_signal('high_score_changed', high_score)


func toggle_game() -> void:
	is_game = !is_game
	emit_signal('game_mode_changed')


func set_balance(value: int, sync_after_set: bool = false) -> void:
	balance = max(0, value)
	SDK.set_data('Balance', balance)
	emit_signal('balance_changed', balance)
	assert(value >= 0, 'set balance < 0')
	if sync_after_set:
		SDK.sync_data()


func add_balance(amount: int, sync_after_add: bool = false) -> void:
	balance += max(0, amount)
	SDK.set_data('Balance', balance)
	emit_signal('balance_changed', balance)
	assert(amount >= 0, 'add balance < 0')
	if sync_after_add:
		SDK.sync_data()


func reduce_balance(amount: int, sync_after_reduce: bool = false) -> void:
	balance -= max(0, amount)
	SDK.set_data('Balance', balance)
	emit_signal('balance_changed', balance)
	assert(amount >= 0, 'reduce balance < 0')
	if sync_after_reduce:
		SDK.sync_data()


func set_high_score(value: int, sync_after_set: bool = false) -> void:
	high_score = max(0, value)
	SDK.set_data('HighScore', high_score)
	emit_signal('high_score_changed', high_score)
	assert(value >= 0, 'set high score < 0')
	if sync_after_set:
		SDK.sync_data()


func cut_number(number: float) -> String:
	var number_size: int = 0
	while number >= 1000:
		number /= 1000
		number_size += 1

	if number < 10:
		number = floor(number * 100) / 100
	else:
		number = floor(number * 10) / 10

	if number_size == 0:
		return str(floor(number))
	elif number_size > cut_number_dic.size():
		return str('> 999.9' + cut_number_dic[cut_number_dic.size()])
	return str(number) + cut_number_dic[number_size]
