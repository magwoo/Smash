extends Control


onready var main_packed: PackedScene = load('res://scenes/interfaces/Main.tscn')

onready var bar: ProgressBar = $LoadMargin/LoadingBar
onready var logo: Sprite = $Logo

var load_progress: float = 0
var load_value: float = 0


func _ready() -> void:
	yield(get_tree().create_timer(0.5), 'timeout')
	load_progress += int(rand_range(5, 20))
	
	while main_packed == null:
		yield(get_tree().create_timer(0.1), 'timeout')
	logo.step += 1
	load_progress += int(rand_range(10, 30))
	
	yield(get_tree().create_timer(0.5), 'timeout')
	load_progress += int(rand_range(0, 30))
	yield(get_tree().create_timer(0.5), 'timeout')
	load_progress += int(rand_range(0, 20))
	
	while !SDK.is_ready():
		yield(get_tree().create_timer(0.1), 'timeout')
	load_progress += 100 - load_progress
	
	yield(get_tree().create_timer(0.5), 'timeout')
	
	logo.step += 1
	
	yield(get_tree().create_timer(1.0), 'timeout')
	
	get_tree().change_scene_to(main_packed)


func _process(_delta: float) -> void:
	load_value = lerp(load_value, load_progress, Global.lerp_index)
	bar.value = load_value
	
	if logo.step > 1:
		bar.modulate.a -= 0.5 * _delta
	else:
		bar.modulate.a = bar.value / 500
