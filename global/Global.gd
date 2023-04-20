extends Node

signal high_score_changed()
signal balance_changed()
signal game_mode_changed()
signal viewport_resized()
signal lang_changed()


const LERP_SPEED: float = 0.25

var buy_particle_packed: PackedScene = load('res://scenes/other/BuyParticles.tscn')

var lerp_index: float = 1.0
var time: float = 0.0
var asint: float = 0.0

var balance: int = 0
var high_score: int = 0

var selected_player: int = 1
var is_game: bool = false
var lang: int = 0 setget _change_lang
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

var sound_packets: Dictionary = {
	'shoot': load('res://resources/sounds/ShootSound.wav'),
	'tap': load('res://resources/sounds/TapSound.wav')
}


func _ready() -> void:
	self.pause_mode = Node.PAUSE_MODE_PROCESS

	SDK.player.connect('player_ready', self, '_player_ready')

	randomize()


func _player_ready() -> void:
	yield(get_tree().create_timer(0.05), 'timeout')

	if SDK.player.get_data('Lang', -1) == -1: lang = SDK.player.get_language() != 'ru'
	else: lang = SDK.player.get_data('Lang', -1)
	if lang: TranslationServer.set_locale('en')
	else: TranslationServer.set_locale('ru')

	set_balance(SDK.player.get_data('Balance', balance))
	set_high_score(SDK.player.get_data('HighScore', high_score))

	sounds = SDK.player.get_data('Sounds', sounds)
	effects = SDK.player.get_data('Effects', effects)

	upgrades = [
		SDK.player.get_data('Upgrade1', 1),
		SDK.player.get_data('Upgrade2', 1),
		SDK.player.get_data('Upgrade3', 1),
		SDK.player.get_data('Upgrade4', 1)
	]


func _process(_delta: float) -> void:
	time += _delta
	lerp_index = LERP_SPEED * _delta * 60
	asint = sin(time)


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed('esc') && OS.has_feature('debug'):
		get_tree().quit()


static func get_lerp_speed() -> float:
	return LERP_SPEED


func reload_info() -> void:
	emit_signal('balance_changed', balance)
	emit_signal('high_score_changed', high_score)


func toggle_game() -> void:
	is_game = !is_game
	emit_signal('game_mode_changed')


func set_balance(value: int, sync_after_set: bool = false) -> void:
	balance = max(0, value)
	SDK.player.set_data('Balance', balance)
	emit_signal('balance_changed', balance)

	assert(value >= 0, 'set balance < 0')

	if sync_after_set: SDK.player.sync_data()


func add_balance(amount: int, sync_after_add: bool = false) -> void:
	balance += max(0, amount)
	SDK.player.set_data('Balance', balance)
	emit_signal('balance_changed', balance)

	assert(amount >= 0, 'add balance < 0')

	if sync_after_add: SDK.player.sync_data()


func reduce_balance(amount: int, sync_after_reduce: bool = false) -> void:
	balance -= max(0, amount)
	SDK.player.set_data('Balance', balance)
	emit_signal('balance_changed', balance)

	assert(amount >= 0, 'reduce balance < 0')

	if sync_after_reduce: SDK.player.sync_data()


func set_high_score(value: int, sync_after_set: bool = false) -> void:
	high_score = max(0, value)
	SDK.player.set_data('HighScore', high_score)
	emit_signal('high_score_changed', high_score)

	assert(value >= 0, 'set high score < 0')

	if sync_after_set: SDK.player.sync_data()


func cut_number(number: float) -> String:
	var number_size: int = 0
	while number >= 1000.0:
		number /= 1000.0
		number_size += 1

	if number < 10: number = floor(number * 100.0) / 100.0
	else: number = floor(number * 10.0) / 10.0

	if number_size == 0: return str(floor(number))
	elif number_size > cut_number_dic.size():
		return str('> 999.9' + cut_number_dic[cut_number_dic.size()])

	return str(number) + cut_number_dic[number_size]


func _change_lang(value: int) -> void:
	lang = value
	emit_signal('lang_changed')
