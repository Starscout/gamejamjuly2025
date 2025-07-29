extends Node2D
@onready var ray_cast: RayCast2D = $RayCast

@onready var anchor: StaticBody2D = $PinJoint2D/Anchor
@onready var pin_joint: PinJoint2D = $PinJoint2D
@onready var rope: Line2D = $Rope
@onready var line_end: Marker2D = $PinJoint2D/Anchor/Marker2D


#@export var rope_force = 100
@export var rope_force = 100

var max_distance = 0.0
var hooked = false
var player


func _ready():
	player = get_parent()
	pin_joint.node_a = get_path_to(player)
	pin_joint.top_level = true

func _process(delta: float) -> void:
	ray_cast.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("activate_tool") and not hooked:
		#ray_cast.target_position = to_local(get_global_mouse_position())
		#ray_cast.force_raycast_update()
		if ray_cast.is_colliding():
			hooked = true
			
			var hook_position = ray_cast.get_collision_point()
			# Uncomment if we need to check what the hook collides with
			# var collider = ray_cast.get_collider()
			pin_joint.global_position = hook_position
			anchor.global_position = hook_position
			pin_joint.node_b = get_path_to(anchor)
			var direction = hook_position - global_position
			anchor.rotation = direction.angle()
			
			max_distance = player.global_position.distance_to(anchor.global_position)
			
	elif Input.is_action_just_released("activate_tool") and hooked:
		hooked = false
		pin_joint.node_b = NodePath("")
	
	if hooked:
		rope.clear_points()
		rope.add_point(to_local(player.position))
		rope.add_point(to_local(line_end.global_position))
		anchor.visible = true
		
		# Shorten/lengthen rope!
		# TODO: Maybe add a limit for how long a rope can go. Will be tied to the max range of rope (Might just be ray length)
		if Input.is_action_pressed("move_up") and ! Input.is_action_pressed("jump"):
			max_distance -= 1.5
		elif Input.is_action_pressed("move_down") and ! Input.is_action_pressed("jump"):
			max_distance += 1.5
		
		var distance = player.global_position.distance_to(anchor.global_position)
		if distance > max_distance:
			# Implementation 1
			#if player.global_position.y > anchor.global_position.y:
				#player.velocity.y -= rope_force
			#if player.global_position.y < anchor.global_position.y:
				#player.velocity.y += rope_force
			#if player.global_position.x > anchor.global_position.x:
				#player.velocity.x -= rope_force
			#if player.global_position.x < anchor.global_position.x:
				#player.velocity.x += rope_force
			# Implementation 2
			#player.global_position = player.global_position.move_toward(anchor.global_position,delta * rope_force * (distance - max_distance))
			# Implementation 3 (Bad, don't use unless you understand how I'm misusing vector stuff!)
			#player.velocity = player.velocity * player.global_position.move_toward(anchor.global_position, delta * rope_force / 2)
			# Implementation 4 (includes Elif on line 71)
			var anchor_vector = Vector2(rope.get_point_position(1).x, rope.get_point_position(1).y)
			anchor_vector = anchor_vector.normalized()
			player.velocity += anchor_vector * rope_force * (distance - max_distance)
		elif player.global_position.y > anchor.global_position.y and player.velocity.y < 0:
			if player.global_position.x > anchor.global_position.x:
				player.velocity.x -= 75
				#player.global_position.x = player.global_position.lerp(anchor.global_position, delta).x
			if player.global_position.x < anchor.global_position.x:
				player.velocity.x += 75
	else:
		anchor.visible = false
		rope.clear_points()
	
