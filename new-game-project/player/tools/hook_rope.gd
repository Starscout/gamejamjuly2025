extends Node2D
@onready var ray_cast: RayCast2D = $RayCast

@onready var anchor: StaticBody2D = $PinJoint2D/Anchor
@onready var pin_joint: PinJoint2D = $PinJoint2D
@onready var rope: Line2D = $Rope
@onready var line_end: Marker2D = $PinJoint2D/Anchor/Marker2D

@export var speed = 10
var hooked = false
var player


func _ready():
	player = get_parent()
	pin_joint.node_a = get_path_to(player)
	pin_joint.top_level = true

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("activate_tool") and not hooked:
		ray_cast.target_position = to_local(get_global_mouse_position())
		ray_cast.force_raycast_update()
		if ray_cast.is_colliding():
			hooked = true
			var hook_position = ray_cast.get_collision_point()
			var collider = ray_cast.get_collider()
			# if collider.is_in_group("Hookable"):
			anchor.global_position = hook_position
			pin_joint.node_b = get_path_to(anchor)
			var direction = hook_position - global_position
			anchor.rotation = direction.angle()
			# if collider block ends here
	elif Input.is_action_just_released("activate_tool") and hooked:
		hooked = false
		pin_joint.node_b = NodePath("")
	
	if hooked:
		rope.clear_points()
		rope.add_point(to_local(player.position))
		rope.add_point(to_local(line_end.global_position))
		anchor.visible = true
	else:
		anchor.visible = false
		rope.clear_points()
	
