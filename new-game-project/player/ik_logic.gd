extends Node2D

var parent 
var right_hand_target_position
var left_hand_target_position

var climbing_start = true

var scalar_value = 2 

var max_frame = 30
var frame = 0

func _ready():
	parent = get_parent() 
	left_hand_target_position = Vector2($"IK Targets/Left_hand_target".get_global_position().x, $"IK Targets/Left_hand_target".get_global_position().y + 300 / scalar_value)
	right_hand_target_position = Vector2($"IK Targets/Right_Hand_target".get_global_position().x, $"IK Targets/Right_Hand_target".get_global_position().y)
func _process(delta):

	#Climbing logic
	if parent.climbing == true:
		if climbing_start == true:
			left_hand_target_position = Vector2(parent.get_global_position().x, parent.get_global_position().y - 40 / scalar_value)
			right_hand_target_position = Vector2(parent.get_global_position().x, parent.get_global_position().y)
			climbing_start = false
		else:
			if parent.global_position.y < right_hand_target_position.y:
				set_climbing_target_point()
			elif parent.global_position.y < left_hand_target_position.y:
				set_climbing_left_target_point()
			#Keeps right hands within bounds
			if $"IK Targets/Right_Hand_target".position.y < -50 / scalar_value:
				right_hand_target_position.y += 5
			if $"IK Targets/Right_Hand_target".position.x > 40 / scalar_value:
				right_hand_target_position.x -= 1
			elif $"IK Targets/Right_Hand_target".position.x < 10 / scalar_value:
				right_hand_target_position.x += 1
			#Keeps left hands within bounds
			if $"IK Targets/Left_hand_target".position.y < -50 / scalar_value:
				left_hand_target_position.y += 5
			if $"IK Targets/Left_hand_target".position.x < -40 / scalar_value:
				left_hand_target_position.x += 1
			elif $"IK Targets/Left_hand_target".position.x > -10 / scalar_value:
				left_hand_target_position.x -= 1
	else:
		climbing_start = true

	if parent.is_on_floor() == true:
		right_hand_target_position.y = (parent.get_global_position().y - 10)
		if $"IK Targets/Right_Hand_target".position.x > 40 / scalar_value:
			right_hand_target_position.x -= 1
		elif $"IK Targets/Right_Hand_target".position.x < 10 / scalar_value:
			right_hand_target_position.x += 1
		left_hand_target_position.y = parent.get_global_position().y - 10
		if $"IK Targets/Left_hand_target".position.x < -40 / scalar_value:
			left_hand_target_position.x += 1
		elif $"IK Targets/Left_hand_target".position.x > -10 / scalar_value:
			left_hand_target_position.x -= 1
	#sets hand targets to modified variable coords
	$"IK Targets/Right_Hand_target".global_position = right_hand_target_position
	$"IK Targets/Left_hand_target".global_position = left_hand_target_position
	
	
	
func set_climbing_target_point():
	if $"IK Targets/Right_Hand_target".position.y > -150 / scalar_value:
		var global_posit = $"IK Targets/Right_Hand_target".get_global_position()
		var tween = create_tween()
		tween.tween_method(func(value): right_hand_target_position.y = value, global_posit.y, global_posit.y-100 / scalar_value,.2)
		if parent.velocity.x < 200:
			global_posit.x += parent.velocity.x/5
		right_hand_target_position = global_posit
		
		
func set_climbing_left_target_point():
	if $"IK Targets/Left_hand_target".position.y > -150 / scalar_value:
		var left_global_posit = $"IK Targets/Left_hand_target".get_global_position()
		var tween = create_tween()
		tween.tween_method(func(value): left_hand_target_position.y = value, left_global_posit.y, left_global_posit.y-100 / scalar_value,.2)
		if parent.velocity.x < -200:
			left_global_posit.x += parent.velocity.x/5
		left_hand_target_position = left_global_posit
	#print($"IK Targets/Left_hand_target".position.x )
