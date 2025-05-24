extends Node2D
@export var value: int


func _on_hex_coin_tree_exiting() -> void:
	SignalBus.return_coins.emit(value)
