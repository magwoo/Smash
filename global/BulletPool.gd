extends Node


onready var bullet_packed: PackedScene = load('res://scenes/gameplay/Bullet.tscn')


var _objects: Array = []
var _currect_num: int = 0

var _return_queue: Array = []


func _process(_delta: float) -> void:
	_clean_queue()


func _ready() -> void:
	update_pool(100)


func update_pool(count: int, delta: float = 0.05) -> void:
	for i in count:
		_objects.append(bullet_packed.instance())
		yield(get_tree().create_timer(0.05), 'timeout')


func clear_pool(count: int = _objects.size()):
	if count == _objects.size(): _objects.clear()
	else: for i in count: _objects.remove(i)


func get_bullet() -> Node:
	if _objects.empty():
		return bullet_packed.instance()
	var _temp_bullet = _objects[0]
	_objects.remove(0)
	return _temp_bullet


func return_bullet(bullet: Node) -> void:
	if _return_queue.has(bullet): return
	_return_queue.append(bullet)


func _clean_queue() -> void:
	while _return_queue.size() != 0:
		var object: Node = _return_queue[0]
		if !is_instance_valid(object):
			_return_queue.remove(0)
			return
		var par: Node = object.get_parent()
		if par == null:
			_return_queue.remove(0)
			return
		par.remove_child(object)
		_return_queue.remove(0)
		_objects.append(object)
