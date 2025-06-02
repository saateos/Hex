extends AspectRatioContainer
var current_value : int = 0
var max_value : int = 10
var worth : int = 1
var text
func _ready() -> void:
	get_child(0).text = "Coins: " + str(current_value) + "/" + str(max_value)

func coin_update():
	current_value = current_value + worth
	if current_value >= max_value:
		current_value = abs(max_value - current_value)
		max_value += 10
		print("UPGRADE")
	self.get_child(0).text = "Coins: " + str(current_value) + "/" + str(max_value)
	#print(current_value)
