extends Node2D

var parent 
var right_hand_target_position
var left_hand

var max_frame = 30
var frame = 0

func _ready():
	parent = get_parent() 
	right_hand_target_position = Vector2(-300, -8)
	set_target_point()
func _process(delta):
	
	
	if parent.global_position.y < right_hand_target_position.y:
		set_target_point()
	
	#$"IK Targets/Right_Hand_target".position.y = clamp($"IK Targets/Right_Hand_target".position.y, -150, 999)

	if $"IK Targets/Right_Hand_target".position.y < -150:
		right_hand_target_position.y += 5
	$"IK Targets/Right_Hand_target".global_position = right_hand_target_position



func get_direction():
	return (parent.velocity)
	
func set_target_point():
	if $"IK Targets/Right_Hand_target".position.y > -150:
		var global_posit = $"IK Targets/Right_Hand_target".get_global_position()
		var tween = create_tween()
		tween.tween_method(func(value): right_hand_target_position.y = value, global_posit.y, global_posit.y-100,.2)
		
		right_hand_target_position = global_posit
