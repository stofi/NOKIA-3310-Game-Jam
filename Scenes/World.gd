extends Node2D

onready var player = $Player
onready var cable = $Cable
var tileset = null 

var steps = []
var step_count = 0

func _ready():
	OS.set_window_position(Vector2.ZERO)
	tileset = cable.get_tileset()
	_on_Player_moved()
	pass # Replace with function body.

	
func _on_Player_moved():
	steps.push_back(cable.world_to_map(player.position))
	step_count = len(steps)
	setCable()

func setCable():
	var current = Vector2.ZERO
	var prev = Vector2.ZERO
	var prev2 = Vector2.ZERO
	var tile_name = 'cable_'
	var tile_index = -1

	if step_count < 2:
		return
	elif step_count == 2:
		current = steps[1]
		prev = steps[0]
		match current - prev:
			Vector2.UP:
				tile_name += 'u'
			Vector2.DOWN:
				tile_name += 'b'
			Vector2.LEFT:
				tile_name += 'l'
			Vector2.RIGHT:
				tile_name += 'r'
	
	else:
		current = steps[step_count-1]
		prev = steps[step_count-2]
		prev2 = steps[step_count-3]
		match [prev-prev2, current - prev]:
			[Vector2.RIGHT, Vector2.UP], [Vector2.DOWN, Vector2.LEFT]:
				tile_name += 'ul'
			[Vector2.LEFT, Vector2.DOWN], [Vector2.UP, Vector2.RIGHT]:
				tile_name += 'br'
			[Vector2.UP, Vector2.LEFT], [Vector2.RIGHT, Vector2.DOWN]:
				tile_name += 'bl'
			[Vector2.DOWN, Vector2.RIGHT], [Vector2.LEFT, Vector2.UP]:
				tile_name += 'ur'
			[Vector2.DOWN, Vector2.DOWN], [Vector2.UP, Vector2.UP]:
				tile_name += 'v'
			[Vector2.RIGHT, Vector2.RIGHT], [Vector2.LEFT, Vector2.LEFT]:
				tile_name += 'h'
			
	tile_index = tileset.find_tile_by_name(tile_name)
	cable.set_cellv(prev, tile_index)
