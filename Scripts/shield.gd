extends AspectRatioContainer
var current_value : int = 0
var max_value : int = 4
var worth : int = 1
var text
func _ready() -> void:
	get_child(0).text = "Armor: " + str(current_value) + "/" + str(max_value)

func shield_update():
	current_value = current_value + worth
	if current_value >= max_value:
		current_value = max_value
	self.get_child(0).text = "Armor: " + str(current_value) + "/" + str(max_value)
