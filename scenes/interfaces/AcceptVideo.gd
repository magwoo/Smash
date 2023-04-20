extends ScaledButton


onready var panel: Panel = $Panel
onready var root: CanvasLayer = $'../../../../..'
var loading: bool = false


func _ready() -> void:
	SDK.ads.connect('reward_ad_closed', self, '_reward')


func _pressed() -> void:
	loading = true
	SDK.ads.show_reward()


func _process(_delta: float) -> void:
	if loading:
		panel.modulate.a = min(1, panel.modulate.a + 2 * _delta)


func _reward(success: bool) -> void:
	if !success: return
	$'../Cancel'._pressed()
	Global.upgrades[0] += 1
	root.selected_button.upgrade()
	root.selected_button.video_avaible = false
	root.selected_button.update_all()

