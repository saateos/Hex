extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func if_is_type(type: String):
	if type == "coin":
		get_tree().call_group("CoinGr", "update_coins")
