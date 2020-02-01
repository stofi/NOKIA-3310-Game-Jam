extends KinematicBody2D

export (int) var speed = 4
export (float) var tick = 0.2

var step = Vector2.ZERO

var _timer = null


func _ready():
	_timer = Timer.new()
	add_child(_timer)

	_timer.connect("timeout", self, "_on_Tick")
	_timer.set_wait_time(tick)
	_timer.set_one_shot(false)
	_timer.start()


func _on_Tick():
	step *= speed
	if not test_move(transform,step):
		position += step
	step = Vector2.ZERO

func get_input():
	if Input.is_action_pressed('move_right'):
		step = Vector2(1,0)
	if Input.is_action_pressed('move_left'):
		step = Vector2(-1,0)
	if Input.is_action_pressed('move_down'):
		step = Vector2(0,1)
	if Input.is_action_pressed('move_up'):
		step = Vector2(0,-1)

func _physics_process(delta):
	get_input()
