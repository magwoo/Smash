extends ScaledButton


onready var tree_node: CanvasLayer = $'../../../..'
onready var tree: Control = get_tree().get_nodes_in_group('MainMenu')[0]


func _pressed() -> void:
	tree_node.is_destroyed = true
