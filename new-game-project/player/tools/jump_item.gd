extends Node2D

@onready var jump_cooldown_timer: Timer = $JumpCooldownTimer

@export var jump_value = 4000

var player
var max_frame:int = 30
var frame:int = 0

signal item_used

func _ready():
	player = get_parent()


func _physics_process(delta):
	if Input.is_action_pressed("activate_tool") and $JumpCooldownTimer.time_left == 0 and player.is_on_floor():
		player.gravity = -jump_value 
		$JumpCooldownTimer.start()
		item_used.emit(jump_cooldown_timer.time_left)
	
	#I think this frame tracker may be slightly bad, RAM wise and performance wise---oh well, later issue.
	frame += 1
	if frame == max_frame:
		player.gravity = 30
		frame = 0
