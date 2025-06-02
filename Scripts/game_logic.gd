extends Node2D


func if_type(type: String):
	if type == "coin":
		get_tree().call_group("CoinGr", "coin_update")
	if type == "shield":
		get_tree().call_group("ShieldGr", "shield_update")
