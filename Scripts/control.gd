extends Control

@export var grid : Node2D

func _ready() -> void:
	self.position = grid.hex_to_pixel(Vector2(grid.half, grid.half))
