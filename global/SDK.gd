extends Node

enum Platforms{
	DEBUG = 0,
	VK = 1,
	YANDEX = 2
}


var _sdk: JavaScriptObject

var _is_debug: bool = OS.has_feature('debug')

var platform: PlatformClass = PlatformClass.new()
var player: PlayerClass = PlayerClass.new()
var ads: AdsClass = AdsClass.new()
var leaderboard: LeaderboardClass = LeaderboardClass.new()
var achievements: AchievementsClass = AchievementsClass.new()
var socials: SocialsClass = SocialsClass.new()


func _ready() -> void:
	var ad_timer: Timer = Timer.new()
	self.add_child(ad_timer)
	self.pause_mode = Node.PAUSE_MODE_PROCESS
	if OS.has_feature('JavaScript') && !OS.has_feature('debug'):
		yield(get_tree().create_timer(0.25), 'timeout')

		var attempt: int = 0
		while _sdk == null:
			if attempt > 100:
				player.emit_signal('player_error')
				self.queue_free()
				break
			yield(get_tree().create_timer(0.1), 'timeout')
			attempt += 1
			_sdk = JavaScript.get_interface('SDK')

		player._init(_sdk)
		ads._init(_sdk, ad_timer)
		leaderboard._init(_sdk)
		achievements._init(_sdk)
		platform._init(_sdk)
		socials._init(_sdk)

		player.sync_data()
	else:
		ads.connect('fullscreen_ad_started', self, '_open_debug_fullscreen_ad')
		ads.connect('reward_ad_started', self, '_open_debug_reward_ad')
		ads.connect('preloader_ad_started', self, '_open_debug_preloader_ad')

		ads._init(null, ad_timer)
		player.sync_data()

		print('SDK: Started at debug mode')


func _open_debug_fullscreen_ad() -> void:
	var window: FullscreenAdClass = FullscreenAdClass.new('FULLSCREEN')

	window.connect('window_closed', ads, '_fullscreen_ad_closed', [[]])
	window.connect('window_closed', ads, '_any_ad_closed', [[]])

	self.add_child(window)


func _open_debug_preloader_ad() -> void:
	var window: FullscreenAdClass = FullscreenAdClass.new('PRELOADER')

	window.connect('window_closed', ads, '_preloader_ad_closed', [[]])
	window.connect('window_closed', ads, '_any_ad_closed', [[]])

	self.add_child(window)


func _open_debug_reward_ad() -> void:
	var window: RewardAdClass = RewardAdClass.new(5)

	window.connect('window_closed', ads, '_reward_ad_closed')
	window.connect('window_closed', ads, '_any_ad_closed')

	self.add_child(window)


class PlayerClass:
	extends Reference
	signal sync_completed(success)
	signal player_ready()
	signal player_error()
	signal player_changed()

	var _sdk: JavaScriptObject
	var _callbacks: Dictionary = {}

	var _is_debug: bool = OS.has_feature('debug')
	var _ls: LocalDataClass
	var _editable_data: Array = []

	var is_ready: bool = false setget , is_ready
	var is_loggedin: bool setget , is_loggedin
	var id: int = randi() setget , id
	var score: int setget set_score , score
	var my_name: String setget , my_name
	var avatar: String setget , avatar
	var language: String = 'ru' setget set_language, get_language

	func _init(sdk: JavaScriptObject = null) -> void:
		if _is_debug: _ls = LocalDataClass.new('cloud')
		if sdk == null: return
		_sdk = sdk
		_callbacks.sync_completed = JavaScript.create_callback(self, '_sync_completed')
		_sdk.player.on('sync', _callbacks.sync_completed)
		_callbacks.player_changed = JavaScript.create_callback(self, '_player_changed')
		_sdk.player.on('change', _callbacks.player_changed)

	func _sync_completed(args: Array) -> void:
		emit_signal('sync_completed', args[0])
		if !is_ready && args[0]:
			if _is_debug: _editable_data = str2var(_ls.get_data('editable_data')) if _ls.get_data('editable_data') != null else []
			else: _editable_data = str2var(_sdk.player.get('editable_data')) if _sdk.player.get('editable_data') != '' else []

			is_ready = true
			emit_signal('player_ready')

	func _player_changed(args: Array) -> void:
		emit_signal('player_changed')

	func _edit_data(key: String) -> void:
		key = key.to_lower()
		if _editable_data.has(key) || key == 'editable_data': return
		_editable_data.append(key)
		if _is_debug: _ls.set_data('editable_data', to_json(_editable_data))
		else: _sdk.player.set('editable_data', to_json(_editable_data))

	func set_language(lang: String) -> void:
		if _is_debug: language = lang
		else: _sdk.changeLanguage(lang)

	func get_language() -> String:
		if _is_debug: return language
		return _sdk.language

	func is_ready() -> bool:
		return is_ready

	func is_loggedin() -> bool:
		if _is_debug: return true
		return _sdk.player.isLoggedIn

	func id() -> int:
		if _is_debug: return id
		return int(_sdk.player.id)

	func score() -> int:
		if _is_debug: return get_data('score', 0)
		return int(_sdk.player.score)

	func set_score(value: int) -> void:
		set_data('score', value)

	func my_name() -> String:
		if _is_debug: return 'Your name'
		return String(_sdk.player.name)

	func avatar() -> String:
		if _is_debug: return 'Avatar link'
		return String(_sdk.player.avatar)

	func sync_data() -> void:
		if _is_debug:
			_ls.sync_data()
			_sync_completed([true])
			print('SDK: Sync player complete')
		else: _sdk.player.sync()

	func set_data(key: String, data, sync_after_write: bool = false, format: bool = false) -> void:
		key = key.to_lower()
		_edit_data(key)
		if format: data = to_json(data)
		if _is_debug:
			_ls.set_data(key, data)
			print('SDK: Success set "%s" at key: ' % [data], key)
		else: _sdk.player.set(key, data)
		if sync_after_write: sync_data()

	func add_data(key: String, value: float, sync_after_write: bool = false) -> void:
		key = key.to_lower()
		_edit_data(key)
		if _is_debug:
			_ls.add_data(key, value)
			print('SDK: Success add "%s" at ' % value, key)
		else: _sdk.player.add(key, value)
		if sync_after_write: sync_data()

	func toggle_data(key: String, sync_after_write: bool = false) -> void:
		key = key.to_lower()
		_edit_data(key)
		if _is_debug:
			_ls.toggle_data(key)
			print('SDK: Success toggle "%s"' % key)
		else: _sdk.player.toggle(key)
		if sync_after_write: sync_data()

	func get_data(key: String, default_value = null, format: bool = false):
		key = key.to_lower()
		if _is_debug:
			var result = _ls.get_data(key) if has_data(key) else default_value
			return str2var(result) if format && result is String else result
		var result = _sdk.player.get(key) if has_data(key) else default_value
		if format && result is String: result = str2var(result)
		return result

	func has_data(key: String) -> bool:
		key = key.to_lower()
		return _editable_data.has(key)

	func reset() -> void:
		if _is_debug:
			_ls.reset_data()
			print('SDK: Success reset player stat')
		else: _sdk.player.reset()

	func remove() -> void:
		if _is_debug:
			_ls.reset_data()
			print('SDK: Success remove player stat')
		else: _sdk.player.remove()

class AdsClass:
	extends Reference
	signal any_ad_started()
	signal any_ad_closed()
	signal fullscreen_ad_started(success)
	signal fullscreen_ad_closed()
	signal preloader_ad_started(success)
	signal preloader_ad_closed()
	signal reward_ad_started(success)
	signal reward_ad_closed(success)
	signal banner_started(success)
	signal banner_refreshed()
	signal banner_closed()

	var _sdk: JavaScriptObject
	var _callbacks: Dictionary = {}

	var _is_debug: bool = OS.has_feature('debug')
	var _timer: Timer
	var _fullscreen_reloaded: bool = true

	var is_adblock_enabled: bool setget , is_adblock_enabled
	var is_banner_available: bool setget , is_banner_available
	var is_fullscreen_available: bool setget , is_fullscreen_available
	var is_reward_available: bool setget , is_reward_available
	var is_preload_available: bool setget , is_preload_available
	var is_banner_playing: bool setget , is_banner_playing
	var is_fullscreen_playing: bool setget , is_fullscreen_playing
	var is_reward_playing: bool setget , is_reward_playing
	var is_preload_playing: bool setget , is_preload_playing

	func _init(sdk: JavaScriptObject = null, timer: Timer = null) -> void:
		if timer == null: return
		_timer = timer
		_timer.one_shot = true
		_timer.connect('timeout', self, '_fullscreen_reloaded')
		if sdk == null: return
		_sdk = sdk
		_callbacks.any_ad_started = JavaScript.create_callback(self, '_any_ad_started')
		_sdk.ads.on('start', _callbacks.any_ad_started)
		_callbacks.any_ad_closed = JavaScript.create_callback(self, '_any_ad_closed')
		_sdk.ads.on('close', _callbacks.any_ad_closed)
		_callbacks.fullscreen_ad_started = JavaScript.create_callback(self, '_fullscreen_ad_started')
		_sdk.ads.on('fullscreen:start', _callbacks.fullscreen_ad_started)
		_callbacks.fullscreen_ad_closed = JavaScript.create_callback(self, '_fullscreen_ad_closed')
		_sdk.ads.on('fullscreen:close', _callbacks.fullscreen_ad_closed)
		_callbacks.preloader_ad_started = JavaScript.create_callback(self, '_preloader_ad_started')
		_sdk.ads.on('preloader:start', _callbacks.preloader_ad_started)
		_callbacks.preloader_ad_closed = JavaScript.create_callback(self, '_preloader_ad_closed')
		_sdk.ads.on('preloader:close', _callbacks.preloader_ad_closed)
		_callbacks.reward_ad_started = JavaScript.create_callback(self, '_reward_ad_started')
		_sdk.ads.on('rewarded:start', _callbacks.reward_ad_started)
		_callbacks.reward_ad_closed = JavaScript.create_callback(self, '_reward_ad_closed')
		_sdk.ads.on('rewarded:close', _callbacks.reward_ad_closed)
		_callbacks.banner_refreshed = JavaScript.create_callback(self, '_banner_refreshed')
		_sdk.ads.on('sticky:refresh', _callbacks.banner_refreshed)
		_callbacks.banner_started = JavaScript.create_callback(self, '_banner_started')
		_sdk.ads.on('sticky:render', _callbacks.banner_started)
		_callbacks.banner_closed = JavaScript.create_callback(self, '_banner_closed')
		_sdk.ads.on('sticky:close', _callbacks.banner_closed)

	func _any_ad_started(args: Array) -> void:
		emit_signal('any_ad_started')

	func _any_ad_closed(args: Array) -> void:
		emit_signal('any_ad_closed')

	func _fullscreen_ad_started(args: Array) -> void:
		emit_signal('fullscreen_ad_started', args[0])

	func _fullscreen_ad_closed(args: Array) -> void:
		if _is_debug: print('SDK: Fullscreen ad closed')
		emit_signal('fullscreen_ad_closed')

	func _fullscreen_reloaded() -> void:
		_fullscreen_reloaded = true

	func _preloader_ad_started(args: Array) -> void:
		emit_signal('preloader_ad_started', args[0])

	func _preloader_ad_closed(args: Array) -> void:
		if _is_debug: print('SDK: Preloader ad closed')
		emit_signal('preloader_ad_closed')

	func _reward_ad_started(args: Array) -> void:
		emit_signal('reward_ad_started', args[0])

	func _reward_ad_closed(args: Array) -> void:
		if _is_debug: print('SDK: Reward closed (%s)' % 'False' if args[0] == null else 'True')
		emit_signal('reward_ad_closed', false if args[0] == null else true)

	func _banner_refreshed(args: Array) -> void:
		if args[0] == null: emit_signal('banner_refreshed')

	func _banner_started(args: Array) -> void:
		emit_signal('banner_started', args[0])

	func _banner_closed(args: Array) -> void:
		emit_signal('banner_closed')

	func is_banner_available() -> bool:
		if _is_debug: return true
		return _sdk.ads.isStickyAvailable

	func is_adblock_enabled() -> bool:
		if _is_debug: return false
		return _sdk.ads.isAdblockEnabled

	func is_fullscreen_available() -> bool:
		if _is_debug: return true
		return _sdk.ads.isFullscreenAvailable

	func is_reward_available() -> bool:
		if _is_debug: return true
		return _sdk.ads.isRewardedAvailable

	func is_preload_available() -> bool:
		if _is_debug: return true
		return _sdk.ads.isPreloaderAvailable

	func is_banner_playing() -> bool:
		if _is_debug: return false
		return _sdk.ads.isStickyPlaying

	func is_fullscreen_playing() -> bool:
		if _is_debug: return false
		return _sdk.ads.isFullscreenPlaying

	func is_reward_playing() -> bool:
		if _is_debug: return false
		return _sdk.ads.isRewardedPlaying

	func is_preload_playing() -> bool:
		if _is_debug: return false
		return _sdk.ads.isPreloaderPlaying

	func show_fullscreen() -> void:
		if !_fullscreen_reloaded:
			if _is_debug: print('SDK: Fullscreen ad reloading: %.1fs.' % _timer.time_left)
			return
		_fullscreen_reloaded = false
		if _is_debug:
			_timer.start(90.0)
			emit_signal('any_ad_started')
			emit_signal('fullscreen_ad_started')
			print('SDK: Fullscreen ad started')
		else:
			var _platform: String = _sdk.platform.type
			_timer.start(90.0 if _platform == 'VK' else 180.0)
			_sdk.ads.showFullscreen()

	func show_preloader() -> void:
		if _is_debug:
			emit_signal('any_ad_started')
			emit_signal('preloader_ad_started')
			print('SDK: Preload ad started')
		else: _sdk.ads.showPreloader()

	func show_reward() -> void:
		if _is_debug:
			emit_signal('any_ad_started')
			emit_signal('reward_ad_started', true)
			print('SDK: Reward ad started')
		else: _sdk.ads.showRewardedVideo()

	func show_banner() -> void:
		if _is_debug:
			emit_signal('any_ad_started')
			emit_signal('banner_started', true)
			print('SDK: Banner started')
		else: _sdk.ads.showSticky()

	func refresh_banner() -> void:
		if _is_debug:
			emit_signal('banner_refreshed')
			print('SDK: Banner refreshed')
		else: _sdk.ads.refreshSticky()

	func close_banner() -> void:
		if _is_debug:
			emit_signal('any_ad_closed')
			emit_signal('banner_closed')
			print('SDK: Banner closed')
		else: _sdk.ads.closeSticky()

class LeaderboardClass:
	extends Reference

	var _sdk: JavaScriptObject

	var _is_debug: bool = OS.has_feature('debug')

	func _init(sdk: JavaScriptObject = null) -> void:
		if sdk == null: return
		_sdk = sdk

	func publish_record(tag: String, value: float) -> void:
		if _is_debug:
			print('SDK: Leaderboard published record [tag: %s, value: %s]' % [tag, value])
			return
		var settings: JavaScriptObject = JavaScript.create_object('Object')
		var values: JavaScriptObject = JavaScript.create_object('Object')
		var window: JavaScriptObject = JavaScript.get_interface('window')
		values[tag] = value
		settings.tag = tag.to_lower()
		settings.variant = tag.to_lower()
		settings.override = true
		settings.record = values
		_sdk.leaderboard.publishRecord(window.lround(settings, tag.to_lower()))

	func open_by_tag(tag: String, limit: int = 25, order: bool = true, with_me: bool = true) -> void:
		if _is_debug:
			print('SDK: Leaderboard open scoped [tag: %s, limit: %s]' % [tag, limit])
			return
		var order_str: String = 'DESC' if order else 'ASC'
		var with_me_str: String = 'last' if with_me else 'none'
		limit = clamp(limit, 1, 100)
		var settings = JavaScript.create_object('Object')
		settings.tag = tag.to_lower()
		settings.variant = tag.to_lower()
		settings.order = order_str
		settings.limit = limit
		settings.withMe = with_me_str
		_sdk.leaderboard.openScoped(settings)

	func open_by_var(order_by: String = 'score', limit: int = 25, order: bool = true, with_me: bool = true) -> void:
		if _is_debug:
			print('SDK: Leaderboard opened [order by: %s, limit: %s]' % [order_by, limit])
			return
		var arr = JavaScript.create_object('Array', 1)
		arr[0] = order_by.to_lower()
		var order_str: String = 'DESC' if order else 'ASC'
		var with_me_str: String = 'last' if with_me else 'none'
		limit = clamp(limit, 1, 100)
		var settings = JavaScript.create_object('Object')
		settings.orderBy = arr
		settings.order = order_str
		settings.limit = limit
		settings.displayFields = arr
		settings.withMe = with_me_str
		_sdk.leaderboard.open(settings)

class AchievementsClass:
	extends Reference

	signal unlocked(tag)
	signal unlock_error(error)
	signal menu_opened()
	signal menu_closed()

	var _sdk: JavaScriptObject
	var _callbacks: Dictionary = {}

	var _is_debug: bool = OS.has_feature('debug')

	func _init(sdk: JavaScriptObject = null) -> void:
		if sdk == null: return
		_sdk = sdk
		_callbacks.unlocked = JavaScript.create_callback(self, '_unlocked')
		_sdk.achievements.on('unlock', _callbacks.unlocked)
		_callbacks.unlock_error = JavaScript.create_callback(self, '_unlock_error')
		_sdk.achievements.on('error:unlock', _callbacks.unlock_error)
		_callbacks.menu_opened = JavaScript.create_callback(self, '_menu_opened')
		_sdk.achievements.on('open', _callbacks.menu_opened)
		_callbacks.menu_closed = JavaScript.create_callback(self, '_menu_closed')
		_sdk.achievements.on('close', _callbacks.menu_closed)

	func _unlocked(args: Array) -> void:
		emit_signal('unlocked', args[0])

	func _unlock_error(args: Array) -> void:
		emit_signal('unlock_error', args[0])

	func _menu_opened(args: Array) -> void:
		if args[0] == null: emit_signal('menu_opened')

	func _menu_closed(args: Array) -> void:
		emit_signal('menu_closed')

	func unlock(tag: String) -> void:
		if _is_debug:
			print('SDK: Unlocked achievement "%s"' % tag)
		else:
			tag = tag.to_lower()
			_sdk.achievements.unlock(tag)

	func open() -> void:
		if _is_debug: print('SDK: Opened achievements menu')
		else: _sdk.achievements.open()

class PlatformClass:
	extends Reference

	enum Platforms{
		DEBUG = 0,
		VK = 1,
		YANDEX = 2
	}

	var _sdk: JavaScriptObject

	var type: int setget _type, type
	var is_mobile: bool setget , is_mobile

	func _init(sdk: JavaScriptObject = null) -> void:
		if OS.has_feature('debug'): type = Platforms.DEBUG
		if sdk == null || type != Platforms.DEBUG: return
		_sdk = sdk
		type = Platforms._sdk.platform.type

	func _type(value: int) -> void:
		printerr('platform type does not setteble')

	func type() -> int:
		return type

	func is_mobile() -> bool:
		if type == Platforms.DEBUG: return false
		return _sdk.isMobile

class SocialsClass:
	extends Reference

	var _sdk: JavaScriptObject

	var _is_debug: bool = OS.has_feature('debug')

	func _init(sdk: JavaScriptObject = null) -> void:
		if sdk == null: return
		_sdk = sdk

	func join_community() -> void:
		if _is_debug: print('SDK: join community called')
		else: OS.shell_open('https://vk.com/evilgamestudio')

class FullscreenAdClass:
	extends CanvasLayer
	signal window_closed()

	var background: Panel = Panel.new()
	var close_button: Button = Button.new()
	var label: Label = Label.new()
	var ad_type: String

	onready var viewport: Vector2 = get_viewport().get_visible_rect().size

	func _init(ad_name: String) -> void:
		ad_type = ad_name

	func _ready() -> void:
		self.layer = 100
		background.rect_position = Vector2()
		background.rect_size = viewport
		close_button.rect_position = Vector2(viewport.x - 48, 16)
		close_button.text = 'X'
		close_button.rect_size = Vector2(32, 32)
		close_button.connect('pressed', self, '_close_window')
		label.text = 'DEBUG ' + ad_type.to_upper() + ' AD'
		label.rect_position = background.rect_position
		label.rect_size = background.rect_size
		label.align = Label.ALIGN_CENTER
		label.valign = Label.VALIGN_CENTER
		self.add_child(background)
		background.add_child(close_button)
		background.add_child(label)

	func _close_window() -> void:
		emit_signal('window_closed')
		self.queue_free()

class RewardAdClass:
	extends CanvasLayer
	signal window_closed(success)

	var background: Panel = Panel.new()
	var close_button: Button = Button.new()
	var label: Label = Label.new()
	var timer: int = 6
	var is_hide: bool = false

	onready var viewport: Vector2 = get_viewport().get_visible_rect().size

	func _init(time: int = 5) -> void:
		timer = time + 1

	func _ready() -> void:
		self.layer = 100
		background.rect_position = Vector2()
		background.rect_size = viewport
		close_button.rect_position = Vector2(viewport.x - 48, 16)
		close_button.text = 'X'
		close_button.rect_size = Vector2(32, 32)
		close_button.connect('pressed', self, '_close_window')
		label.rect_position = background.rect_position
		label.rect_size = background.rect_size
		label.align = Label.ALIGN_CENTER
		label.valign = Label.VALIGN_CENTER
		self.add_child(background)
		background.add_child(close_button)
		background.add_child(label)
		while timer > 0:
			timer -= 1
			label.text = 'DEBUG REWARD AD. WAIT ' + str(timer) + ' SECONDS'
			yield(get_tree().create_timer(1.0), 'timeout')
		label.text = 'DEBUG REWARD AD. YOU CAN CLOSE IT'
		if self.is_hide: self.queue_free()

	func _close_window() -> void:
		if timer == 0:
			emit_signal('window_closed', [true])
			self.queue_free()
		else:
			emit_signal('window_closed', [null])
			self.hide()
			is_hide = true

class LocalDataClass:
	extends Reference

	var manager: File = File.new()

	var data: Dictionary = {}
	var path: String

	func _init(filepath: String) -> void:
		path = filepath
		if manager.file_exists('user://%s.json' % path):
			manager.open('user://%s.json' % path, File.READ)
			data = str2var(manager.get_as_text())
			manager.close()

	func set_data(key: String, value) -> void:
		key = key.to_lower()
		data[key] = value

	func add_data(key: String, value: float, sync_after_save: bool = false) -> void:
		key = key.to_lower()
		data[key] = data[key] + value
		if sync_after_save: sync_data()

	func toggle_data(key: String, sync_after_save: bool = false) -> void:
		key = key.to_lower()
		data[key] = !data[key]
		if sync_after_save: sync_data()

	func get_data(key: String):
		key = key.to_lower()
		if !data.has(key): return null
		return data[key]

	func reset_data():
		data = {'###': '###'}
		sync_data()

	func sync_data() -> void:
		if data.empty(): return
		manager.open('user://%s.json' % path, File.WRITE)
		manager.store_string(to_json(data))
		manager.close()
