extends Node2D

@onready var raycasts: Node2D = $Raycasts

var motion = Vector2()

var hook_position = Vector2()
var hooked = false
var max_length = 50
var length
@export var player: CharacterBody2D


func _ready():
	var length = max_length

func _physics_process(delta: float) -> void:
	hook()
	if hooked:
		swing(delta)
		motion *= 0.975 # Speed of swing
		
		# Here's where we'd affect player velocity based on motion calculations
		#You slowfall because 'motion.y' == 0, then set that equal to the 'velocity.y'. Why setting the velocity to 0 doesn't stop us, I don't know
		player.velocity.x = motion.x
		player.velocity.y = motion.y
	
	

func _draw():
	var position = global_position
	
	if hooked:
		draw_line(Vector2(0, 0), to_local(hook_position), Color(0.35, 0.7, 0.9), 3)
		
		var colliding = $Raycasts.is_colliding()
		var collide_point = $Raycasts.get_collision_pont()
		if colliding and position.distance_to(collide_point) < length:
			draw_line(Vector2(0,0), to_local(collide_point), Color(1,1,1,0.25), 0.5, true)
			 
#Simply has the raycasts look at our mouse and when we press the button we set the hook_position to where the collision happened and then get the length to there
func hook() -> void:
	$Raycasts.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("activate_tool"):
		hook_position = get_hook_position()
		if hook_position:
			hooked = true
			length = global_position.distance_to(hook_position)
	if Input.is_action_just_released("activate_tool") and hooked:
		hooked = false

#This gets what raycast collided what where we colliding.
func get_hook_position():
	for raycast in $Raycasts.get_children():
		if raycast.is_colliding():
			return raycast.get_collision_point()

func swing(delta):
	var radius = global_position - hook_position
	#motion.length() is always 0 right now and radius.length() is always greater than 10, so we don't go forward from here.
	if motion.length() < 0.01 or radius.length() > 10: return 
	#If we do, however, we will crash because of dividing by zero, as motion.length() alwasy seems to be 0.
	var angle = acos(radius.dot(motion) / (radius.length() * motion.length()))
	var rad_vel = cos(angle) * motion.length()
	#I assume, though I do not understand the 'acos' and 'cos' stuff, that this is trying to make the player move in angle of the collision.
	motion += radius.normalized() * -rad_vel
	
	if global_position.distance_to(hook_position) > length:
		global_position = hook_position + radius.normalized() * length
	#This also crashes the game, for some reason?
	motion += (hook_position - global_position.normalized) * 15000 * delta
