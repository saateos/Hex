extends Node2D

var current_health: int
@export var max_health: int
signal on_death

func update_health():
	if current_health <=0:
		current_health = 0
		on_death.emit()
	pass

func damage():
	pass

func heal():
	pass
