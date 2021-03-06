extends KinematicBody2D

export (int) var speed = 4

var step = Vector2.ZERO
signal moved
var enabled = false

func _ready():
	pass

func _on_Tick():
	step *= speed
	if step.length() > 0 and not test_move(transform, step):
		position += step
		emit_signal("moved")
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

func _physics_process(_delta):
	if enabled:
		get_input()


func disable():
	enabled = false
	
func enable():
	enabled = true
	
