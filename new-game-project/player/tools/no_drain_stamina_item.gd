extends Node2D

var player
var can_activate:bool = true

func _ready():
	player = get_parent()

func _physics_process(delta):
	if Input.is_action_pressed("activate_tool") and can_activate:
		player.stamina_drain = 0
		player.stamina_can_drain = false
		$NoDrainStaminaItemTimer.start()
		can_activate = false

func _on_no_drain_stamina_item_timer_timeout():
	player.stamina_drain = 0.5
	player.stamina_can_drain = true
	$NoDrnStmnCooldown.start()

func _on_no_drn_stmn_cooldown_timeout():
	can_activate = true
