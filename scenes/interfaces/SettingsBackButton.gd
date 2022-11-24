extends ScaledButton


onready var tree_node: Control = $'../../../../..'


func _pressed() -> void:
	tree_node.is_blured = false
