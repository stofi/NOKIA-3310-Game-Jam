extends Node2D

onready var player = $Player
onready var cable = $Cable

var steps = []
var step_count = 0

func _ready():
	pass # Replace with function body.

func _on_Player_moved():
	steps.push_back(cable.world_to_map(player.position))

	step_count = len(steps)
	if step_count > 1:
		setCable()

func setCable():
	var current = steps[step_count-1]
	var last = steps[step_count-2]
# 	var tile_player = cable.world_to_map(pos)
# 	var tile_pos = cable.world_to_map(pos)
# 	var tile_last = cable.world_to_map(last)
# 	var direction = tile_pos - tile_last
# 	var direction = tile_pos - tile_last
	# var tileset = cable.get_tileset()
	# var u = tileset.find_tile_by_name('cable_u')
	# cable.set_cellv(pos, 0)
	# cable.set_cell(tile_pos.x, tile_pos.y, 0, false, false, false, Vector2.ZERO)
	# cable.update_bitmask_area(tile_pos)
