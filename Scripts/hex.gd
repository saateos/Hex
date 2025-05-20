extends Node2D

@export var hex_type: String

func dim():
	var hex = get_node("Hex")
	hex.modulate.a = .5
func disappear():
	var tween:Tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0,0), .5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(self.queue_free)
