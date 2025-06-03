extends Node2D
# переменные
var coords_grid = []
var spawned_grid = []
var grid_math = GridMath.new()
var possible_hexes = [
	preload("uid://co1op7rdm2tnr"), #skull
	preload("uid://c48a42sogpyo3"), #sword
	preload("uid://cew7dfm10wcyd"), #shield
	preload("uid://b3u2v0vhu2mim"), #heal
	preload("uid://dkwfx76jqq7g") #coin
]
var line = preload("uid://bf501npeoutn4") #arrow
var arrow = line.instantiate()

var select = []
var controlling = false
# функция запуска
func _ready():
	coords_grid = grid_math.set_hex(grid_math.create_grid())
	spawned_grid = grid_math.create_grid()
	add_child(arrow)
	spawn()
func _process(_delta):
	touch_input()
# регистрируем нажатие
func touch_input():
	var mouse_coords = get_global_mouse_position()
	var touch = grid_math.pixel_to_hex(mouse_coords)
	if grid_math.is_in_grid(coords_grid, touch):
		if Input.is_action_just_pressed("touch"):
			select.append(touch)
			arrow.add_point(grid_math.hex_to_pixel(touch))
			print("current click:" + str(grid_math.pixel_to_hex(mouse_coords)))
			controlling = true
		var current_hex = grid_math.get_hex(coords_grid, spawned_grid, touch)
		if Input.is_action_pressed("touch") and controlling and current_hex != null:
			# проверяем, что два последних хекса одного вида и соседи
			var current_type = grid_math.get_hex(coords_grid, spawned_grid, touch).hex_type
			var previous_type = grid_math.get_hex(coords_grid, spawned_grid, select[-1]).hex_type
			if current_type == previous_type and grid_math.is_neighbor(touch, select[-1]):
				if touch not in select:
					select.append(touch)
					arrow.add_point(grid_math.hex_to_pixel(touch))
				elif select.find(touch)==select.size()-2:
					select.pop_back()
					arrow.remove_point(arrow.get_point_count() - 1)
	if Input.is_action_just_released("touch"):
		if is_completed_chain(select):
			chain_behavior(select)
		collapse()
		select.clear()
		arrow.clear_points()
		get_parent().get_node("Grid/spawn_timer").start()
		controlling = false
# цепочка из 3х и больше элементов
func is_completed_chain(array: Array):
	if array.size() >= 3:
		return true
# взоимодействие с цепочкой, что делать после мэтча
func chain_behavior(chain: Array):
	for i in chain:
		var hex = grid_math.get_hex(coords_grid, spawned_grid, i)
		hex.disappear()
		var index = grid_math.get_hex_index(coords_grid, i)
		spawned_grid[index.x][index.y] = null
# коллапсим столбцы
func collapse() -> void:
	for k in grid_math.width:
		for i in grid_math.width:
			for j in (2 * grid_math.half + 1) - abs(grid_math.half - i):
				if spawned_grid[i][j] == null:
						var next_hex_coords = coords_grid[i][j] + Vector2(0, -1)
						if grid_math.is_in_grid(coords_grid, next_hex_coords) and grid_math.get_hex(coords_grid, spawned_grid, next_hex_coords) != null:
							var next_index = grid_math.get_hex_index(coords_grid, next_hex_coords)
							spawned_grid[next_index.x][next_index.y].move(grid_math.hex_to_pixel(coords_grid[i][j]))
							spawned_grid[i][j] = spawned_grid[next_index.x][next_index.y]
							spawned_grid[next_index.x][next_index.y] = null
# Спавним хексы
func spawn() -> void:
	if grid_math.is_has_null(spawned_grid):
		for i in grid_math.width:
			for j in (2 * grid_math.half + 1) - abs(grid_math.half - i):
				if spawned_grid[i][j] == null:
					var hex = possible_hexes.pick_random().instantiate()
					add_child(hex)
					hex.position = grid_math.hex_to_pixel(coords_grid[i][j])
					spawned_grid[i][j] = hex
					hex.appear()

func _on_spawn_timer_timeout() -> void:
	spawn()
