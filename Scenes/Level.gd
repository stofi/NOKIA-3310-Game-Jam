extends Node2D
# 19x10
const WIDTH = 20
const HEIGHT = 11
const MAX_OBSTACLES = int(floor((WIDTH-1)*(HEIGHT-1)/2))

onready var player = $Player
onready var goal = $Goal
onready var start = $Start
onready var enemy = $Enemy
onready var nav = $Nav
onready var map = $Nav/Map

var difficulty = 1
var tileset = null

func r0(n): # from 0 to n
	return randi()%(n+1)

func r(n): # from 1 to n
	var o = randi()%n+1 
	return o

func _ready():
	randomize()
	tileset = map.get_tileset()
	generate()
	if len(findpath(player.position, goal.position)) == 0:
		reset_level()
		generate()
	pass
	
func reset_level():
	start.position = Vector2(-10,-10)
	goal.position = Vector2(-10,-15)
	enemy.position = Vector2(-10,-20)
	player.position = Vector2(-10,-25)
	for x in range(1,WIDTH):
		for y in range(1,HEIGHT):
			map.set_cell(x, y, tileset.find_tile_by_name('empty'))
			map.update_bitmask_area(Vector2(x,y))
	yield(get_tree(), "idle_frame")

func generate():
	print('generating level')
	print('	difficulty ', difficulty)
	var obstacles = min(MAX_OBSTACLES, (difficulty * 3))
	print('	obstacles ', obstacles)
	place_goal()
	place_start()
	place_enemy()
	place_player()
	for _i in range(obstacles):
		var obs_pos = place_obstacle()
		yield(get_tree(), "idle_frame")
		if len(findpath(start.position, goal.position)) == 0:
			remove_obstacle(obs_pos)
			break
	yield(get_tree(), "idle_frame")
	
func random_tile():
	return Vector2(r(WIDTH-1),r(HEIGHT-1))

func place_goal():
	var pos = Vector2(WIDTH-1, r(HEIGHT-1))
	map.set_cellv(pos, tileset.find_tile_by_name('object'))
	goal.position = map.map_to_world(pos) + Vector2(2,2)

func place_start():
	var pos = Vector2(1, r(HEIGHT-1))
	map.set_cellv(pos, tileset.find_tile_by_name('object'))
	start.position = map.map_to_world(pos) + Vector2(2,2)

func place_enemy():
	var pos = Vector2(r(WIDTH-2)+1,r(HEIGHT-1))
	map.set_cellv(pos, tileset.find_tile_by_name('object'))
	enemy.position = map.map_to_world(pos) + Vector2(2,2)
	
func place_player():
	player.position = start.position
	map._on_Player_moved()	

func place_obstacle():
	var pos = random_tile()
	while map.get_cellv(pos) != tileset.find_tile_by_name('empty'):
		pos = random_tile()
		
	map.set_cellv(pos, 0)
	map.update_bitmask_area(pos)
	return pos

func remove_obstacle(pos):
	map.set_cellv(pos, tileset.find_tile_by_name('empty'))
	map.update_bitmask_area(pos)

func win():
	difficulty += 1
	reset_level()
	generate()
	emit_signal("win")

func loose():
	difficulty = 1
	reset_level()
	generate()
	print("loose")
	emit_signal("loose")

func findpath(a,b):
	return nav.get_simple_path(a, b)

func _on_Player_moved():
	if player.position == goal.position:
		win()
	elif (player.position - enemy.position).length() <= 4:
		loose()
	elif len(findpath(player.position, goal.position)) == 0:
		loose()
