extends Node2D
# переменные
var grid = []
var possible_pieces = [
	preload("uid://co1op7rdm2tnr"), #skull
	preload("uid://c48a42sogpyo3"), #sword
	preload("uid://cew7dfm10wcyd"), #shield
	preload("uid://b3u2v0vhu2mim"), #heal
	preload("uid://dkwfx76jqq7g") #coin
]
@export var pointy = false
@export var side = 4
@export var offset = 5
@export var size = 123

var size_off = size + offset
var width : int = ( side * 2 ) - 1
var half : int = (width / 2)
var select = []
# функция запуска
func _ready():
	grid = create_grid()
	grid = set_hex(grid)
	camera_centre()
	spawn()
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
func pixel_to_hex(touch):
	var q
	var r
	if pointy == true:
		q = (-1./3 * touch.y + sqrt(3)/3 * touch.x) / size_off
		r = (2./3 * touch.y) / size_off
	else:
		q = (2./3 * touch.x) / size_off
		r = (-1./3 * touch.x  +  sqrt(3)/3 * touch.y) / size_off
	return axial_round(Vector2(q, r))
# регистрируем нажатие
var touch = Vector2(0, 0)
func touch_input():
	var mouse_coords = get_global_mouse_position()
	if Input.is_action_just_pressed("touch"):
		touch = pixel_to_hex(mouse_coords)
		print(pixel_to_hex(mouse_coords))
		select.append(touch)
	if Input.is_action_just_released("touch"):
		print(select)
		#select.clear()

# получаем индексы хекс координат
func find_hex_index(array, hex):
	for i in array.size():
		for j in array[i].size():
			if array[i][j] == hex:
				return Vector2(i, j)
# Спавним хексы
func spawn():
	for i in grid.size():
		for j in grid[i].size():
			var piece = possible_pieces.pick_random().instantiate()
			add_child(piece)
			piece.position = hex_to_pixel(grid[i][j])
			if pointy == true:
				piece.get_child(0).rotation_degrees = 90
# центруем камеру по сетке
func camera_centre():
	%Camera.position = hex_to_pixel(Vector2(half, half))
func _process(delta):
	touch_input()
# хуйхухуй
# AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
