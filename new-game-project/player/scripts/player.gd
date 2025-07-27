extends CharacterBody2D

@export var speed:float = 150
@export var gravity:float = 30
@export var jump_power:float = 600
@export var max_stamina:float = 100.0
@export var lunge_cost:float = 10
@export var max_velocity:float = 800
@export var stamina_drain:float = 0.5
@export var stamina_regen:float = 5 #0.8
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


var jumping:bool = false
var climbing:bool = false
var stamina:float = max_stamina
var is_near_wall:bool = false
var lunge_is_ready:bool = true
var stamina_can_regen:bool = true
var stamina_can_drain:bool = true


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
			#Why do we have this if-statement?
			if stamina+2 < max_stamina:
				stamina += 0.8
		stamina += stamina_regen 
	
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
	animation_logic()
	#print(velocity)
	#print(str($CollisionShape2D/PlayerSprite.animation))

#Qucik fix so you only lose climbing when leaving the Background. Did a match becues it felt like fun and if we wanted diffrent background 
#thought it would be easier for rapid testing.
func _on_area_2d_body_entered(body: Node2D) -> void:
	match body.name:
		"Background":
			is_near_wall = true
		"Clay":
			if stamina_can_drain == true:
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


func animation_logic():
	#Idle logic. These numbers only work becues they come at the end of the _physics_process. If this func. comes earlier then y will need to be 30.
	if velocity == Vector2(0,0) and is_on_floor():
		$CollisionShape2D/PlayerSprite.play("Idle")
	#Jumping/Falling logic
	if velocity.y != 0 and is_on_floor() == false and climbing == false and jumping == false:
		$CollisionShape2D/PlayerSprite.play("Falling")
	elif velocity.y < 0 and climbing == false and climbing == false and jumping == true:
		$CollisionShape2D/PlayerSprite.play("Jump")
	#Walking logic with direction.
	if velocity.x > 0 and is_on_floor() and climbing == false:
		$CollisionShape2D/PlayerSprite.play("Walk")
		$CollisionShape2D/PlayerSprite.flip_h = velocity.x > 0
	elif velocity.x < 0 and is_on_floor() and climbing == false:
		$CollisionShape2D/PlayerSprite.play("Walk")
		$CollisionShape2D/PlayerSprite.flip_h = false
	#Climbing logic.
	if velocity == Vector2(0, 0) and climbing == true:
		$CollisionShape2D/PlayerSprite.play("Climbing")
		$CollisionShape2D/PlayerSprite.stop()
	elif velocity != Vector2(0, 0) and climbing == true:
		$CollisionShape2D/PlayerSprite.play("Climbing")
