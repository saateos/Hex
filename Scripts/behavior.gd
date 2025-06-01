extends Node2D
@export var value: int
var current_tree
func _ready() -> void:
	current_tree = get_tree()

func _on_hex_coin_tree_exiting() -> void:
	current_tree.call_group("coin", "update_coins")
