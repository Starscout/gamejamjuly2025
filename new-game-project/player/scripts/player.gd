extends CharacterBody2D

@export var speed:float = 150
@export var gravity:float = 30
@export var jump_power:float = 600
@export var max_stamina:float = 100.0
@export var lunge_cost:float = 10
@export var max_velocity:float = 800
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var jumping:bool = false
var climbing:bool = false
var stamina:float = max_stamina
var is_near_wall:bool = false


func _physics_process(_delta: float) -> void:
	var horizontal_input = (
			Input.get_action_strength("move_right")
			- Input.get_action_strength("move_left")
		)
	var vertical_input = (
			Input.get_action_strength("move_down")
			- Input.get_action_strength("move_up")
		)
		
	velocity.x = horizontal_input * speed
	velocity.y += gravity
	
	# Jump when on ground
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_power
		jumping = true
	
	# Player releases jump whenever they want to stop forcing jumpstate, otherwise reset when they hit floor.
	if Input.is_action_just_released("jump") or is_on_floor() and velocity.y > 0:
		jumping = false
		climbing = false
	
	# If not forcing jump state, player can climb!
	if Input.is_action_pressed("jump") and jumping == false and is_near_wall and stamina > 0:
		# Ignore gravity for climbing state -- May want to adjust this to actually affect gravity if any downward forces are added to climbing logic
		velocity.y = 0 + vertical_input * speed
		climbing = true
		stamina -= 0.5
		#TODO: Add delay before stamina regen
	elif not climbing and stamina < max_stamina:
		if is_on_floor():
			if stamina+2 < max_stamina:
				stamina += 2
		stamina += 0.5
	
	# You can still lunge with less than the lunge cost because that's intentional
	if Input.is_action_just_pressed("lunge") and climbing and stamina > 0:
		stamina -= lunge_cost
		#TODO: Make this use an animation or a lerp or something else instead so it ain't so jumpy!
		velocity.x += horizontal_input * speed * 20
		velocity.y += vertical_input * speed * 20
	normalize_velocity()
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	is_near_wall = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	is_near_wall = false
	

func normalize_velocity():
	if velocity.x > max_velocity:
		velocity.x = max_velocity
	if velocity.x < -max_velocity:
		velocity.x = -max_velocity
	if velocity.y > max_velocity:
		velocity.y = max_velocity
	if velocity.y < -max_velocity:
		velocity.y = -max_velocity
