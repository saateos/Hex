extends Node2D

@export var hex_type: String

func dim():
	var hex = get_node("Hex")
	hex.modulate.a = .5
