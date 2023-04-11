extends ScaledButton


onready var bar: ProgressBar = $ProgressBar
onready var anim: AnimationPlayer = $AnimationPlayer
onready var label: Label = $Label
onready var price: Label = $Price

var default_style: StyleBoxFlat = load('res://resources/themes/BarStyle.tres')
var style: StyleBoxFlat

const not_avaible_color: Color = Color(0.37, 0.37, 0.37)
const avaible_color: Color = Color(0.94, 0.66, 0.34)

var target_value: float = 0.0
var target_color: Color = Color()
var value: float = 0.0
var once: bool = true
var is_avaiable: bool = false


func _ready() -> void:
	self.text = Global.translate('#PLAY')
	label.text = Global.translate('#BUY')
	style = default_style.duplicate()
	target_color = avaible_color
	bar.set('custom_styles/fg', style)


func _pressed() -> void:
	if Global.player_dic[Global.selected_player].has:
		Global.toggle_game()
	elif Global.balance >= Global.player_dic[Global.selected_player].price:
		Global.reduce_balance(Global.player_dic[Global.selected_player].price)
		Global.player_dic[Global.selected_player].has = true

		var particle: CPUParticles2D = Global.buy_particle_packed.instance()
		particle.position = self.rect_pivot_offset
		particle.emission_rect_extents = self.rect_size / 2.0
		particle.amount = 32
		self.add_child(particle)
		particle.emitting = true
	else:
		anim.stop()
		anim.play('buy_not_avaible')


func _process(_delta: float) -> void:
	if Global.player_dic[Global.selected_player].has:
		self.self_modulate.a = lerp(self.self_modulate.a, 1.0, Global.lerp_index)

		once = true

		if self.self_modulate.a > 0.95:
			bar.visible = false
			label.visible = false
	else:
		style.bg_color = lerp(style.bg_color, target_color, Global.lerp_index)
		self.self_modulate.a = lerp(self.self_modulate.a, 0.0, Global.lerp_index)

		is_avaiable = target_value == 1
		if is_avaiable:
			target_color = avaible_color
			price.text = Global.cut_number(Global.player_dic[Global.selected_player].price)
		else:
			price.text = Global.cut_number(Global.balance) + '/' + Global.cut_number(Global.player_dic[Global.selected_player].price)
			target_color = not_avaible_color

		if once:
			bar.visible = true
			label.visible = true
			target_color = avaible_color
			style.bg_color = avaible_color
			value = 1.2
			once = false

		target_value = min(
			1.0, Global.balance / float(Global.player_dic[Global.selected_player].price)
		)
		value = lerp(value, target_value, Global.lerp_index)
		bar.value = value + 0.25
