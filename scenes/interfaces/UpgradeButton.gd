extends ScaledButton


onready var bar: ProgressBar = $ProgressBar
onready var level_text: Label = $TextMargin/Level
onready var cost_text: Label = $TextMargin/Cost
onready var anim: AnimationPlayer = $AnimationPlayer
onready var video: Sprite = $Video
onready var video_packed: PackedScene = load('res://scenes/interfaces/UpgradeVideo.tscn')

var default_style: StyleBoxFlat = load('res://resources/themes/BarStyle.tres')
var style: StyleBoxFlat

const not_avaible_color: Color = Color(0.37, 0.37, 0.37)
const avaible_color: Color = Color(0.94, 0.66, 0.34)
const video_color: Color = Color(0.4, 0.65, 0.35)

export(int) var buy_cost: int = 0
export(int, 1, 4) var index: int = 1

var target_value: float = 0.0
var target_color: Color = Color()
var value: float = 0.0
var cost: int = 1
var is_avaiable: bool = false
var video_avaible: bool = false

export var name_tag: String


func _ready() -> void:
	style = default_style.duplicate()
	bar.set('custom_styles/fg', style)
	target_color = self.modulate
	update_all()
	Global.connect('lang_changed', self, '_lang_changed')
	Global.connect('balance_changed', self, '_update_all')


func _process(_delta: float) -> void:
	value = lerp(value, target_value, Global.lerp_index)
	bar.value = value + 0.2
	style.bg_color = lerp(style.bg_color, target_color, Global.lerp_index)
	if video.visible:
		video.rotation = deg2rad(sin(Global.time * 3.0) * 10.0 + 15.0)


func _pressed() -> void:
	if Global.balance >= cost:
		Global.reduce_balance(cost)
		upgrade()
	else:
		if video_avaible:
			var video: CanvasLayer = video_packed.instance()
			video.selected_button = self
			$'/root'.add_child(video)
		else:
			anim.stop()
			anim.play('buy_not_avaible')


func upgrade() -> void:
	Global.upgrades[index - 1] += 1
	var particle: CPUParticles2D = Global.buy_particle_packed.instance()
	particle.position = self.rect_pivot_offset
	particle.emission_rect_extents = self.rect_size / 2.0
	self.add_child(particle)
	particle.emitting = true
	SDK.player.set_data('Upgrade' + str(index), Global.upgrades[index - 1], true)


func _update_all(balance: int = 0) -> void:
	self.call_deferred('update_all')


func update_all() -> void:
	video.visible = false
	cost = buy_cost * pow(Global.upgrades[index - 1], 2.0)
	cost_text.text = Global.cut_number(Global.balance) + '/' + Global.cut_number(cost)
	level_text.text = self.tr('#LEVEL') + ' ' + str(Global.upgrades[index - 1])
	target_value = min(1.0, Global.balance / float(cost))
	is_avaiable = target_value == 1
	if is_avaiable:
		cost_text.text = Global.cut_number(cost)
		target_color = avaible_color
	else:
		if video_avaible:
			cost_text.text = self.tr('#FREE')
			target_color = video_color
			target_value = 1
			video.visible = true
		else:
			cost_text.text = Global.cut_number(Global.balance) + '/' + Global.cut_number(cost)
			target_color = not_avaible_color


func _lang_changed() -> void:
	level_text.text = self.tr('#LEVEL') + ' ' + str(Global.upgrades[index - 1])
