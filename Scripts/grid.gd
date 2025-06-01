extends Node2D
class_name Grid
# переменные
var coords_grid = []
var spawned_grid = []
var possible_hexes = [
	preload("uid://co1op7rdm2tnr"), #skull
	preload("uid://c48a42sogpyo3"), #sword
	preload("uid://cew7dfm10wcyd"), #shield
	preload("uid://b3u2v0vhu2mim"), #heal
	preload("uid://dkwfx76jqq7g") #coin
]
var line = preload("uid://bf501npeoutn4") #arrow
var arrow = line.instantiate()
@export var side = 4
@export var offset = 100
@export var gap = 5
@export var size = 123

var width : int = ( side * 2 ) - 1
var half : int = side - 1

var touch = Vector2(0, 0)
var select = []
var controlling = false

# функция запуска
func _ready():
	coords_grid = set_hex(create_grid())
	spawned_grid = create_grid()
	add_child(arrow)
	spawn()

func _process(_delta):
	touch_input()
# создаем сетку хексов
func create_grid():
	var array = []
	for i in width:
		array.append([])
		for j in (2 * half + 1) - abs(half - i):
			array[i].append(null)
	return array
# записываем в сетку векторы координат
func set_hex(array):
	for i in array.size():
		for j in array[i].size():
			array[i][j] = Vector2(j + max(0, half - i), i) # pointy-top
	return array
# координаты хексов в координаты в пикселях
func hex_to_pixel(hex):
	var x
	var y
	x = (size + gap) * (sqrt(3) * hex.x + sqrt(3)/2 * hex.y)
	y = (size + gap) * (3./2 * hex.y)
	return Vector2 (x, y)
# округление хекс координат
func axial_round(vector):
	var xgrid = round(vector.x)
	var ygrid = round(vector.y)
	vector.x -= xgrid
	vector.y -= ygrid
	if abs(vector.x) >= abs(vector.y):
		return Vector2(xgrid + round(vector.x + 0.5 * vector.y), ygrid)
	else:
		return Vector2(xgrid, ygrid + round(vector.y + 0.5 * vector.x))
# координаты пикселей в координаты хексов
func pixel_to_hex(touchCoords):
	var q = (-1./3 * touchCoords.y + sqrt(3)/3 * touchCoords.x) / (size + gap)
	var r = (2./3 * touchCoords.y) / (size + gap)
	return axial_round(Vector2(q, r))
# регистрируем нажатие
func touch_input():
	var mouse_coords = get_global_mouse_position()
	touch = pixel_to_hex(mouse_coords)
	if is_in_grid(coords_grid, touch):
		if Input.is_action_just_pressed("touch"):
			select.append(touch)
			arrow.add_point(hex_to_pixel(touch))
			print("current click:" + str(pixel_to_hex(mouse_coords)))
			#print("next hex:" + str(pixel_to_hex(mouse_coords) + Vector2(0, -1)))
			controlling = true
		if Input.is_action_pressed("touch") and controlling and get_hex(coords_grid, touch) != null:
			# проверяем, что два последних хекса одного вида и соседи
			if get_hex(coords_grid, select[-1]).hex_type == get_hex(coords_grid, touch).hex_type and is_neighbor(touch, select[-1]):
				if touch not in select:
					#print(pixel_to_hex(mouse_coords))
					select.append(touch)
					arrow.add_point(hex_to_pixel(touch))
					#print(select)
				elif select.find(touch)==select.size()-2:
					select.pop_back()
					arrow.remove_point(arrow.get_point_count() - 1)
					#print(select)
	if Input.is_action_just_released("touch"):
		#print(select)
		if is_completed_chain(select):
			chain_behavior(select)
		select.clear()
		arrow.clear_points()
		collapse()
		controlling = false
		get_parent().get_node("grid/spawn_timer").start()
# получаем индексы хекс координат
func find_hex_index(array, hex):
	for i in array.size():
		for j in array[i].size():
			if  hex == array[i][j]:
				return Vector2(i, j)
# получаем хекс по индексам массива массивов
func get_hex(current_grid, hex):
	var indexes = find_hex_index(current_grid, hex)
	return spawned_grid[indexes.x][indexes.y]
# проверяем находится ли клетка в сетке
func is_in_grid(array, hex):
	for i in array.size():
		if hex in array[i]:
			return true
# проверям является ли ячейка соседом
func is_neighbor(hex_1, hex_2):
	var directions = [
		Vector2(1, 0), Vector2(1, -1), Vector2(0, -1),
		Vector2(-1, 0), Vector2(-1, 1), Vector2(0, 1)
	]
	if hex_1 - hex_2 in directions:
		return true
func is_has_null(array):
	for i in array.size():
		for j in array[i].size():
			if array[i][j] == null:
				return true
# цепочка из 3х и больше элементов
func is_completed_chain(array):
	if array.size() >= 3:
		return true
# взоимодействие с цепочкой, что делать после мэтча
func chain_behavior(array):
	for i in array:
		get_hex(coords_grid, i).disappear()
		var index = find_hex_index(coords_grid, i)
		spawned_grid[index.x][index.y] = null
# коллапсим столбцы
func collapse():
	for k in width:
		for i in width:
			for j in (2 * half + 1) - abs(half - i):
				if spawned_grid[i][j] == null:
						var next_hex = coords_grid[i][j] + Vector2(0, -1)
						if is_in_grid(coords_grid, next_hex) and get_hex(coords_grid, next_hex) != null:
							var next_index = find_hex_index(coords_grid, next_hex)
							spawned_grid[next_index.x][next_index.y].move(hex_to_pixel(coords_grid[i][j]))
							spawned_grid[i][j] = spawned_grid[next_index.x][next_index.y]
							spawned_grid[next_index.x][next_index.y] = null
# Спавним хексы
func spawn():
	if is_has_null(spawned_grid):
		for i in width:
			for j in (2 * half + 1) - abs(half - i):
				if spawned_grid[i][j] == null:
					var hex = possible_hexes.pick_random().instantiate()
					add_child(hex)
					hex.position = hex_to_pixel(coords_grid[i][j])
					spawned_grid[i][j] = hex
					hex.appear()

func _on_spawn_timer_timeout() -> void:
	spawn()
