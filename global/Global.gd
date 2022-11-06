extends Node


const lerp_speed: float = 0.3

var lerp_index: float = 1.0
var time: float = 0.0
var asint: float = 0.0



func _process(_delta: float) -> void:
	time += _delta
	lerp_index = lerp_speed * _delta * 60
	asint = abs(sin(time))
	
