extends Node
class_name GridMath
# основные переменные
@export var side = 4
@export var gap = 5
@export var size = 123
var width : int = ( side * 2 ) - 1
var half : int = side - 1
# создаем пустой массив масиивов для шестиугольной сетки
func create_grid() -> Array:
	var array = []
	for i in width:
		array.append([])
		for j in (2 * half + 1) - abs(half - i):
			array[i].append(null)
	return array
	# записываем в сетку векторы координат
func set_hex(array: Array) -> Array:
	for i in array.size():
		for j in array[i].size():
			array[i][j] = Vector2(j + max(0, half - i), i) # pointy-top
	return array
	# переводим координаты хексов в координаты в пикселях
func hex_to_pixel(hex: Vector2) -> Vector2:
	var x
	var y
	x = (size + gap) * (sqrt(3) * hex.x + sqrt(3)/2 * hex.y)
	y = (size + gap) * (3./2 * hex.y)
	return Vector2 (x, y)
# округление хекс координат
func axial_round(vector: Vector2) -> Vector2:
	var xgrid = round(vector.x)
	var ygrid = round(vector.y)
	vector.x -= xgrid
	vector.y -= ygrid
	if abs(vector.x) >= abs(vector.y):
		return Vector2(xgrid + round(vector.x + 0.5 * vector.y), ygrid)
	else:
		return Vector2(xgrid, ygrid + round(vector.y + 0.5 * vector.x))
# координаты пикселей в координаты хексов
func pixel_to_hex(pixel_coords: Vector2) -> Vector2:
	var q = (-1./3 * pixel_coords.y + sqrt(3)/3 * pixel_coords.x) / (size + gap)
	var r = (2./3 * pixel_coords.y) / (size + gap)
	return axial_round(Vector2(q, r))
# получаем индексы хекс координат
func get_hex_index(array: Array, hex: Vector2):
	for i in array.size():
		for j in array[i].size():
			if  hex == array[i][j]:
				return Vector2(i, j)
				
# получаем хекс по индексам массива массивов
func get_hex(coords: Array, spawned: Array, hex: Vector2):
	var indexes = get_hex_index(coords, hex)
	return spawned[indexes.x][indexes.y]
# проверяем находится ли клетка в сетке
func is_in_grid(array: Array, hex: Vector2):
	for i in array.size():
		if hex in array[i]:
			return true
# проверям является ли ячейка соседом
func is_neighbor(hex_1: Vector2, hex_2: Vector2):
	var directions = [
		Vector2(1, 0), Vector2(1, -1), Vector2(0, -1),
		Vector2(-1, 0), Vector2(-1, 1), Vector2(0, 1)
	]
	if hex_1 - hex_2 in directions:
		return true
# проверяем есть ли ячейки с null
func is_has_null(array: Array):
	for i in array.size():
		for j in array[i].size():
			if array[i][j] == null:
				return true
