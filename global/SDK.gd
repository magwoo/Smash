extends Node


signal sync_success()
signal cloud_ready()
signal reward_closed(success)

var _gs: JavaScriptObject
var _ready: bool = false
var _is_debug: bool = false
var _is_cloud_ready: bool = false
var _ad_timer: float = 0.0

onready var _cb_reward_closed: JavaScriptObject
onready var _cb_sync_complete: JavaScriptObject

const _error_timeout: float = 0.25
const _ad_reload_time: int = 90


func _ready() -> void:
	if OS.has_feature('JavaScript'):
		while _gs == null:
			yield(get_tree().create_timer(_error_timeout * 2), 'timeout')
			_gs = JavaScript.get_interface('gameScore')
		
		_cb_reward_closed = JavaScript.create_callback(self, '_reward_ad_closed')
		_cb_sync_complete = JavaScript.create_callback(self, '_sync_complete')
		_gs.ads.on('rewarded:close', _cb_reward_closed)
		_gs.player.on('sync', _cb_sync_complete)
		
		_gs.player.sync()
	
	else:
		_is_debug = true
		_ready = false
	
	_ad_timer = _ad_reload_time


func _process(_delta: float) -> void:
	_ad_timer += _delta


func _reward_ad_closed(args: Array) -> void:
	var success: bool = bool(args[0])
	emit_signal('reward_closed', success)


func _sync_complete(args: Array) -> void:
	var success: bool = bool(args[0])
	if success:
		emit_signal('sync_success')
		if !_is_cloud_ready:
			_is_cloud_ready = true
			emit_signal('cloud_ready')
		_ready = true
	else:
		sync_data()


func is_ready() -> bool:
	if _is_debug:
		return true
	return _ready


func show_fullscreen_ad() -> void:
	if _ad_timer < _ad_reload_time:
		print('Ad reloading')
		return
	if _is_debug:
		print('Show fullscreen ad successfull')
		_ad_timer = 0
		return
	if is_ready():
		_gs.ads.showFullscreen()
		_ad_timer = 0
	else:
		yield(get_tree().create_timer(_error_timeout), 'timeout')
		show_fullscreen_ad()


func show_reward_ad() -> void:
	if _is_debug:
		print('Show reward ad successfull')
		emit_signal('reward_closed', true)
		return
	if is_ready():
		_gs.ads.showRewardedVideo()
	else:
		yield(get_tree().create_timer(_error_timeout), 'timeout')
		show_reward_ad()


func open_leaderboard(order_by: String = 'score', limit: int = 25, order: bool = true) -> void:
	if _is_debug: return
	
	var arr = JavaScript.create_object('Array', 1)
	arr[0] = order_by.to_lower()
	
	var order_str: String
	if order: order_str = 'DESC'
	else: order_str = 'ASC'
	
	limit = clamp(limit, 1, 100)
	
	var obj = JavaScript.create_object('Object')
	obj.orderBy = arr
	obj.order = order_str
	obj.limit = limit
	obj.displayFields = arr
	obj.withMe = 'last'
	
	_gs.leaderboard.open(obj)


func sync_data() -> void:
	if _is_debug:
		print('Sync successfull')
		return
	if is_ready():
		_gs.player.sync()
	else:
		yield(get_tree().create_timer(_error_timeout), 'timeout')
		sync_data()


func set_data(key: String, value: float, sync_after_set: bool = false) -> void:
	if _is_debug:
		print('Set data ' + str(value) + ' at ' + key + ' successfull')
		return
	key = key.to_lower()
	if is_ready():
		_gs.player.set(key, value)
		if sync_after_set:
			sync_data()
	else:
		yield(get_tree().create_timer(_error_timeout), 'timeout')
		set_data(key, value, sync_after_set)


func set_string_data(key: String, value: String, sync_after_set: bool = false) -> void:
	if _is_debug:
		print('Set data ' + value + ' at ' + key + ' successfull')
		return
	key = key.to_lower()
	if is_ready():
		_gs.player.set(key, value)
		if sync_after_set:
			sync_data()
	else:
		yield(get_tree().create_timer(_error_timeout), 'timeout')
		set_string_data(key, value, sync_after_set)


func set_bool_data(key: String, value: bool, sync_after_set: bool = false) -> void:
	if _is_debug:
		print('Set data ' + str(value) + ' at ' + key + ' successfull')
		return
	key = key.to_lower()
	if is_ready():
		_gs.player.set(key, value)
		if sync_after_set:
			sync_data()
	else:
		yield(get_tree().create_timer(_error_timeout), 'timeout')
		set_bool_data(key, value, sync_after_set)


func get_data(key: String) -> float:
	if _is_debug:
		print('Get data ' + str(key) + ' successfull')
		return .0
	key = key.to_lower()
	print(key)
	if is_ready():
		return float(_gs.player.get(key))
	else:
		return .0


func get_string_data(key: String) -> String:
	if _is_debug:
		print('Get data ' + str(key) + ' successfull')
		return ''
	key = key.to_lower()
	if is_ready():
		return str(_gs.player.get(key))
	else:
		return ''


func get_bool_data(key: String) -> bool:
	if _is_debug:
		print('Get data ' + str(key) + ' successfull')
		return false
	key = key.to_lower()
	if is_ready():
		return bool(_gs.player.get(key))
	else:
		return false
