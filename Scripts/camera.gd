extends Camera2D
var grid = Grid.new()

func _ready() -> void:
	self.position = grid.hex_to_pixel(Vector2(grid.half, grid.half))
