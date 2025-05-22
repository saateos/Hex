extends Node2D
#переменные
@export var hex_type: String
@export var color: Color
# анимации
func move(target):
	var tween:Tween = create_tween()
	tween.tween_property(self, "position", target, .5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN).set_delay(.3)
func appear():
	var tween:Tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0, 0), 0)
	tween.tween_property(self, "scale", Vector2(1, 1), .5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)
func disappear():
	var tween:Tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0,0), .5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(self.queue_free)
func _ready():
	get_node("sprite").modulate = color
