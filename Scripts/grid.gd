extends Node2D
# переменные
var grid = []
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
@export var pointy = false
@export var side = 5
@export var offset = 5
@export var size = 123

var size_off = size + offset
var width : int = ( side * 2 ) - 1
var half : int = (width / 2)

var touch = Vector2(0, 0)
var select = []
var controlling = false

# функция запуска
func _ready():
	grid = create_grid()
	grid = set_hex(grid)
	spawned_grid = create_grid()
	camera_centre()
	add_child(arrow)
	spawn()

func _process(delta):
	touch_input()
	collapse()
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
			if pointy == true:
				array[i][j] = Vector2(j + max(0, half - i), i) # pointy-top
			else:
				array[i][j] = Vector2(i, j + max(0, half - i)) # flat-top
	return array
# координаты хексов в координаты в пикселях
func hex_to_pixel(hex):
	var x
	var y
	x = size_off * (sqrt(3) * hex.x + sqrt(3)/2 * hex.y)
	y = size_off * (3./2 * hex.y)
	if pointy == true:
		return Vector2 (x, y)
	else:
		return Vector2(y, x)
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
	var q
	var r
	if pointy == true:
		q = (-1./3 * touchCoords.y + sqrt(3)/3 * touchCoords.x) / size_off
		r = (2./3 * touchCoords.y) / size_off
	else:
		q = (2./3 * touchCoords.x) / size_off
		r = (-1./3 * touchCoords.x  +  sqrt(3)/3 * touchCoords.y) / size_off
	return axial_round(Vector2(q, r))
# регистрируем нажатие
func touch_input():
	var mouse_coords = get_global_mouse_position()
	touch = pixel_to_hex(mouse_coords)
	if is_in_grid(grid, touch):
		if Input.is_action_just_pressed("touch"):
			select.append(touch)
			arrow.add_point(hex_to_pixel(touch))
			print("current click:" + str(pixel_to_hex(mouse_coords)))
			print("next hex:" + str(pixel_to_hex(mouse_coords) + Vector2(0, -1)))
			controlling = true
		if Input.is_action_pressed("touch") and controlling and get_hex(grid, touch) != null:
			# проверяем, что два последних хекса одного вида и соседи
			if get_hex(grid, select[-1]).hex_type == get_hex(grid, touch).hex_type and is_neighbor(touch, select[-1]):
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
		
		controlling = false
# получаем индексы хекс координат
func find_hex_index(array, hex):
	for i in array.size():
		for j in array[i].size():
			if array[i][j] == hex:
				return Vector2(i, j)
# получаем хекс по индексам массива массивов
func get_hex(grid, hex):
	var indexes = find_hex_index(grid, hex)
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
# цепочка из 3х и больше элементов
func is_completed_chain(array):
	if array.size() >= 3:
		return true
# взоимодействие с цепочкой, что делать после мэтча
func chain_behavior(array):
	for i in array.size():
		get_hex(grid, array[i]).disappear()
		var index = find_hex_index(grid, array[i])
		spawned_grid[index.x][index.y] = null
func collapse():
	for i in width:
		for j in (2 * half + 1) - abs(half - i):
			if spawned_grid[i][j] == null:
				for k in width:
					var next_hex = grid[i][j] + Vector2(0, -1)
					if is_in_grid(grid, next_hex) and get_hex(grid, next_hex) != null:
						var next_index = find_hex_index(grid, next_hex)
						spawned_grid[next_index.x][next_index.y].move(hex_to_pixel(grid[i][j]))
						spawned_grid[i][j] = spawned_grid[next_index.x][next_index.y]
						spawned_grid[next_index.x][next_index.y] = null
# Спавним хексы
func spawn():
	for i in grid.size():
		for j in grid[i].size():
			var hex = possible_hexes.pick_random().instantiate()
			add_child(hex)
			hex.position = hex_to_pixel(grid[i][j])
			if pointy == true:
				hex.get_child(0).rotation_degrees = 90
			spawned_grid[i][j] = hex
# центруем камеру по сетке
func camera_centre():
	%Camera.position = hex_to_pixel(Vector2(half, half))
