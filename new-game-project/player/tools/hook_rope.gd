extends Node2D
@onready var rope: Sprite2D = $Brown
var target_rotation = 0.0
var min_length = 1.0
var max_length = 15.0
var current_length = min_length
var target_length = max_length / 2
@export var extend_ratio = 0.02
@export var rotate_ratio = 0.1

var spinning = false

func _physics_process(delta: float) -> void:
	
	if Input.is_action_pressed("activate_tool"):
		extend_ratio = 0.02
		rotate_ratio = 0.1
		target_rotation = rope.rotation + (deg_to_rad(90))
		target_length = max_length / 2
		spinning = true
	elif Input.is_action_just_released("activate_tool"):
		extend_ratio = 0.1
		target_length = max_length
		target_rotation = rope.rotation + (deg_to_rad(90))


	if spinning:
		current_length = lerp(current_length, target_length, extend_ratio)
		rope.rotation = lerp(rope.rotation,target_rotation, rotate_ratio)
		rope.global_scale = Vector2(current_length, 1)
