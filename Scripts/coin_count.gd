extends Label
var current_value = 0
var max_value = 10
var worth = 1
func _ready() -> void:
	text = "Coins: " + str(current_value) + "/" + str(max_value)

func coin_update():
	current_value = current_value + worth
	if current_value >= max_value:
		current_value = abs(max_value - current_value)
		max_value += 10
		print("UPGRADE")
	text = "Coins: " + str(current_value) + "/" + str(max_value)
