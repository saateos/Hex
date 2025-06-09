extends Label
var current_value : int = 0
var max_value : int = 4
var worth : int = 1
func _ready() -> void:
	text = "Armor: " + str(current_value) + "/" + str(max_value)

func shield_update():
	current_value = current_value + worth
	if current_value >= max_value:
		current_value = max_value
	text = "Armor: " + str(current_value) + "/" + str(max_value)
