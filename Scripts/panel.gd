extends Panel
var grid = Grid.new()
var half_view
var center

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	half_view = get_viewport_rect().size / 2.0
	center = grid.hex_to_pixel(Vector2(grid.half, grid.half)) - half_view
	self.position = center
