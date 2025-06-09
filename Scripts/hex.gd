extends Node2D
#переменные
@export_enum("coin", "shield", "heal", "sword","skull") var type: String
@export_enum("attack", "coin", "shield", "heal") var purpose: String
@export var color: Color
var current_tree
# анимации
func move(target):
	var tween:Tween = create_tween()
	tween.tween_property(self, "position", target, .5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN).set_delay(.3)
func appear():
	var tween:Tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0, 0), 0)
	tween.tween_property(self, "scale", Vector2(1, 1), .5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)
func disappear():
	if type != "skull!!!":
		var tween:Tween = create_tween()
		tween.tween_property(self, "scale", Vector2(0,0), .5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)
		tween.tween_callback(self.queue_free)
func move_disappear(target):
	var tween:Tween = create_tween()
	tween.tween_property(self, "position", target, .5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.set_parallel()
	tween.tween_property(self, "scale", Vector2(0,0), .8).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)
func _ready():
	get_node("sprite").modulate = color
	current_tree = get_tree()


#func _on_tree_exiting() -> void:
	#current_tree.call_group("GameLogic", "if_type", hex_type)
