extends Node2D

var parent 
var right_hand
var left_hand

var max_frame = 30
var frame = 0

func _ready():
	parent = get_parent()
	right_hand = $"IK Targets/Right_Hand_target"
	left_hand = $"IK Targets/Left_hand_target"

func _process(delta):
	if frame < max_frame:
		frame += 1
	else:
		frame = 0
		set_target_point()
	
func get_direction():
	pass

func set_target_point():
	$"IK Targets/Right_Hand_target".position.y = randi_range(-100, 100)
