extends Node2D

onready var level = $Level
onready var splash = $Splash
onready var newlevel = $Newlevel
onready var label = $Newlevel/Label

var enabled = false
var end = false


func _ready():
	OS.set_window_position(Vector2.ZERO)

func _on_Level_win():
	disable()
	level.difficulty += 1
	newlevel.visible = true
	label.text = 'Level '+str(level.difficulty)
	level.reset_level()
	level.generate()
	pass

func _on_Level_loose():
	disable()
	newlevel.visible = true
	label.text = 'You died'
	end = true
	pass

func _on_Level_generated():
	enable()
	pass

func disable():
	enabled = false
	level.disable()
	
func enable():
	enabled = true

func start():
	level.enable()
	newlevel.visible = false
	splash.visible = false
	pass

func prepare():
	end = false
	splash.visible = true
	level.difficulty = 1
	level.reset_level()
	level.generate()


func get_input():
	if Input.is_action_just_pressed('exit'):
		# reset
		pass

func _physics_process(_delta):
	get_input()
	
func _unhandled_input(event):
	if event is InputEventKey:
			if event.pressed and event.scancode == KEY_ESCAPE:
				get_tree().quit()
			elif end:
				prepare()
			elif enabled:
				start()

