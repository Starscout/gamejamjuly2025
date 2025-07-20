extends CharacterBody2D

@export var speed:float = 150
@export var gravity:float = 30
@export var jump_power:float = 600
@export var max_stamina:float = 100.0
@export var lunge_cost:float = 10
@export var max_velocity:float = 800
@export var stamina_drain:float = 0.5
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var jumping:bool = false
var climbing:bool = false
var stamina:float = max_stamina
var is_near_wall:bool = false
var lunge_is_ready:bool = true
var stamina_can_regen:bool = true


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
		velocity.y = 0 + vertical_input * (speed / 1.4)
		velocity.x = 0 + horizontal_input * (speed / 1.4)
		climbing = true
		stamina -= stamina_drain
		stamina_can_regen = false
		$StaminaRegenDelay.start()
		#TODO: Add delay before stamina regen
		#TODO: Kinda done...
	elif not climbing and stamina < max_stamina and stamina_can_regen == true:
		if is_on_floor():
			if stamina+2 < max_stamina:
				stamina += 0.8
		stamina += stamina_drain
	
	# You can still lunge with less than the lunge cost because that's intentional
	if Input.is_action_just_pressed("lunge") and climbing and lunge_is_ready and stamina > 0:
		stamina -= lunge_cost
		#TODO: Make this use an animation or a lerp or something else instead so it ain't so jumpy!
		velocity.x += horizontal_input * speed * 40
		velocity.y += vertical_input * speed * 40
		lunge_is_ready = false
		$LungeCooldown.start()
	normalize_velocity()
	move_and_slide()

#Qucik fix so you only lose climbing when leaving the Background. Did a match becues it felt like fun and if we wanted diffrent background 
#thought it would be easier for rapid testing.
func _on_area_2d_body_entered(body: Node2D) -> void:
	match body.name:
		"Background":
			is_near_wall = true
		"Clay":
			stamina_drain += 0.5
			#speed = speed/2

func _on_area_2d_body_exited(body: Node2D) -> void:
	match body.name:
		"Background":
			is_near_wall = false
		"Clay":
			stamina_drain -= 0.5
			#speed = speed * 2

func normalize_velocity():
	if velocity.x > max_velocity:
		velocity.x = max_velocity
	if velocity.x < -max_velocity:
		velocity.x = -max_velocity
	if velocity.y > max_velocity:
		velocity.y = max_velocity
	if velocity.y < -max_velocity:
		velocity.y = -max_velocity


func _on_lunge_cooldown_timeout():
	lunge_is_ready = true


func _on_stamina_regen_delay_timeout():
	stamina_can_regen = true
