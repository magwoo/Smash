extends Control


onready var main_packed: PackedScene = load('res://scenes/interfaces/Main.tscn')

onready var bar: ProgressBar = $LoadMargin/LoadingBar
onready var logo: Sprite = $Logo

var load_progress: float = 0.0
var load_value: float = 0.0


func _ready() -> void:
	self.get_tree().connect('screen_resized', self, 'update_viewport')

	yield(get_tree().create_timer(0.5), 'timeout')
	load_progress += int(rand_range(5.0, 20.0))

	while main_packed == null: yield(get_tree().create_timer(0.1), 'timeout')
	logo.step += 1
	yield(get_tree().create_timer(0.25), 'timeout')
	load_progress += int(rand_range(10.0, 25.0))

	yield(get_tree().create_timer(0.5), 'timeout')
	load_progress += int(rand_range(0.0, 30.0))

	yield(get_tree().create_timer(0.5), 'timeout')
	load_progress += int(rand_range(0.0, 20.0))

	while !SDK.player.is_ready(): yield(self.get_tree().create_timer(0.1), 'timeout')
	load_progress += 100.0 - load_progress

	yield(get_tree().create_timer(0.5), 'timeout')

	logo.step += 1

	yield(get_tree().create_timer(1.0), 'timeout')

	get_tree().change_scene_to(main_packed)


func _process(_delta: float) -> void:
	load_value = lerp(load_value, load_progress, Global.lerp_index)
	bar.value = load_value

	if logo.step > 1: bar.modulate.a -= 0.5 * _delta
	else: bar.modulate.a = bar.value / 500.0


func update_viewport() -> void:
	logo.center()
