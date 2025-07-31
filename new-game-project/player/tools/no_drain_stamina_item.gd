extends Node2D

var player
var can_activate:bool = true

signal item_used

func _ready():
	player = get_parent()

func _physics_process(delta):
	if Input.is_action_pressed("activate_tool") and can_activate:
		player.stamina_drain = 0
		player.stamina_can_drain = false
		$NoDrainStaminaItemTimer.start()
		$NoDrnStmnCooldown.start()
		item_used.emit($NoDrnStmnCooldown.time_left)
		can_activate = false

func _on_no_drain_stamina_item_timer_timeout():
	player.stamina_drain = 0.5
	player.stamina_can_drain = true


func _on_no_drn_stmn_cooldown_timeout():
	can_activate = true
