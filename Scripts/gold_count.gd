extends Label
var total : int = 0

func _ready() -> void:
	text = "Coins: " + str(total)
	SignalBus.return_coins.connect(update_coins)
	

func update_coins(value):
	total = total + value
	text = "Coins: " + str(total)
