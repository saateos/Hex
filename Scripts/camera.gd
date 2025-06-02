extends Camera2D
var grid_math = GridMath.new()

func _ready() -> void:
	self.position = grid_math.hex_to_pixel(Vector2(grid_math.half, grid_math.half))
