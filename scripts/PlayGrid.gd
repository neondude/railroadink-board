extends Node2D

onready var tile_grid = get_node("TileGrid")
onready var cursor = get_node("Cursor")
onready var cursor_tip = get_node("Cursor/Cursor")


var tool_type
var tool_ability
var tool_texture



func _ready():
	cursor.visible = false


func _input(event):
	if event is InputEventMouse:
		var coords = (tile_grid.to_local(event.position) / tile_grid.cell_size).floor()
		if event is InputEventMouseMotion:
			update_cursor(coords)
		if event is InputEventMouseButton and event.is_pressed() and is_inside_playgrid(coords):
			if tool_type != "apply":
				modify_tile(coords, tool_type)
			else:
				set_tile(coords, tool_ability)

func update_cursor(coords):
	if coords == null:
		if cursor != null:
			cursor.visible = false
	else:
		if cursor != null:
			cursor.visible = is_inside_playgrid(coords)
			cursor.position = tile_grid.map_to_world(coords)
			
func is_inside_playgrid(coords):
	if coords.x < 0 or coords.x >= 7:
		return false
	if coords.y < 0 or coords.y >= 7:
		return false
	return true

func set_tile(coords, selection):
	tile_grid.set_cellv(coords, selection)
	pass

func modify_tile(coords, modification):
	var current_tile = tile_grid.get_cellv(coords)
	match modification:
		"rotate":
			rotate_tile(coords)
		"flip":
			tile_grid.set_cellv(coords,
			current_tile,
			!tile_grid.is_cell_x_flipped(coords.x, coords.y),
			tile_grid.is_cell_y_flipped(coords.x, coords.y),
			tile_grid.is_cell_transposed(coords.x, coords.y))
		"delete":
			tile_grid.set_cellv(coords, -1)


#const bool normal_rotation_matrix[][3] = {
#		{ false, false, false },
#		{ true, true, false },
#		{ false, true, true },
#		{ true, false, true }
#	};
const normal_rotation_matrix = [[false, false, false],
								[true, true, false],
								[false, true, true],
								[true, false, true]]
#	const bool mirrored_rotation_matrix[][3] = {
#		{ false, true, false },
#		{ true, true, true },
#		{ false, false, true },
#		{ true, false, false }
#	};
const mirrored_rotation_matrix = [[false, true, false],
								[true, true, true],
								[false, false, true],
								[true, false, false]]
#

#
#	if (transpose ^ flip_h ^ flip_v) {
#		// Odd number of flags activated = mirrored rotation
#		for (int i = 0; i < 4; i++) {
#			if (transpose == mirrored_rotation_matrix[i][0] &&
#					flip_h == mirrored_rotation_matrix[i][1] &&
#					flip_v == mirrored_rotation_matrix[i][2]) {
#				int new_id = Math::wrapi(i + steps, 0, 4);
#				transpose = mirrored_rotation_matrix[new_id][0];
#				flip_h = mirrored_rotation_matrix[new_id][1];
#				flip_v = mirrored_rotation_matrix[new_id][2];
#				break;
#			}
#		}
#	} else {
#		// Even number of flags activated = normal rotation
#		for (int i = 0; i < 4; i++) {
#			if (transpose == normal_rotation_matrix[i][0] &&
#					flip_h == normal_rotation_matrix[i][1] &&
#					flip_v == normal_rotation_matrix[i][2]) {
#				int new_id = Math::wrapi(i + steps, 0, 4);
#				transpose = normal_rotation_matrix[new_id][0];
#				flip_h = normal_rotation_matrix[new_id][1];
#				flip_v = normal_rotation_matrix[new_id][2];
#				break;
#			}
#		}
#	}

func rotate_tile(coords):
	var current_tile = tile_grid.get_cellv(coords)
	var flip_x = tile_grid.is_cell_x_flipped(coords.x, coords.y)
	var flip_y = tile_grid.is_cell_y_flipped(coords.x, coords.y)
	var transpose = tile_grid.is_cell_transposed(coords.x, coords.y)
	if transpose != flip_x != flip_y:
		for i in range(4):
			if transpose == mirrored_rotation_matrix[i][0] and \
			flip_x == mirrored_rotation_matrix[i][1] and \
			flip_y == mirrored_rotation_matrix[i][2]:
				var new_id = wrapi(i + 1, 0, 4)
				transpose = mirrored_rotation_matrix[new_id][0]
				flip_x = mirrored_rotation_matrix[new_id][1]
				flip_y = mirrored_rotation_matrix[new_id][2]
				break
	else:
		for i in range(4):
			if transpose == normal_rotation_matrix[i][0] and \
			flip_x == normal_rotation_matrix[i][1] and \
			flip_y == normal_rotation_matrix[i][2]:
				var new_id = wrapi(i + 1, 0, 4)
				transpose = normal_rotation_matrix[new_id][0]
				flip_x = normal_rotation_matrix[new_id][1]
				flip_y = normal_rotation_matrix[new_id][2]
				break
	
	tile_grid.set_cellv(coords, current_tile, flip_x, flip_y, transpose)
