extends ScaledButton


onready var bar: ProgressBar = $ProgressBar
onready var name_text: Label = $TextMargin/Name
onready var level_text: Label = $TextMargin/Level
onready var cost_text: Label = $TextMargin/Cost
onready var anim: AnimationPlayer = $AnimationPlayer

var default_style: StyleBoxFlat = load('res://resources/themes/BarStyle.tres')
var style: StyleBoxFlat 

const not_avaible_color: Color = Color(0.37, 0.37, 0.37)
const avaible_color: Color = Color(0.94, 0.66, 0.34)

export(int) var buy_cost: int = 0
export(int, 1, 4) var index: int = 1

var target_value: float = 0
var target_color: Color = Color()
var value: float = 0
var cost: int = 1
var is_avaiable: bool = false


func _ready() -> void:
	style = default_style.duplicate()
	bar.set('custom_styles/fg', style)
	target_color = self.modulate
	update_all()
	Global.connect('balance_changed', self, '_update_all')


func _process(_delta: float) -> void:
	value = lerp(value, target_value, Global.lerp_index)
	bar.value = value + 0.2
	style.bg_color = lerp(style.bg_color, target_color, Global.lerp_index)
	


func _button_pressed() -> void:
	if Global.balance >= cost:
		Global.reduce_balance(cost)
		Global.upgrades[index - 1] += 1
		var particle: CPUParticles2D = Global.buy_particle_packed.instance()
		particle.position = self.rect_pivot_offset
		particle.emission_rect_extents = self.rect_size / 2
		self.add_child(particle)
		particle.emitting = true
	else:
		anim.stop()
		anim.play('buy_not_avaible')


func _update_all(balance: int = 0) -> void:
	self.call_deferred('update_all')


func update_all() -> void:
	cost = buy_cost * pow(Global.upgrades[index - 1], 2)
	cost_text.text = Global.cut_number(cost)
	level_text.text = 'УРОВЕНЬ ' + str(Global.upgrades[index - 1])
	target_value = min(1, Global.balance / float(cost))
	is_avaiable = target_value == 1
	if is_avaiable:
		target_color = avaible_color
	else:
		target_color = not_avaible_color
	
