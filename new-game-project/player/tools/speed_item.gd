extends Node2D

@onready var speed_cooldown_timer: Timer = $SpeedCooldownTimer
@export var speed_boost:float = 2
var player

signal item_used

func _ready():
	player = get_parent()

func _physics_process(delta):
	if Input.is_action_pressed("activate_tool") and $SpeedCooldownTimer.time_left == 0:
		player.speed = player.speed * speed_boost
		$SpeedItemTimer.start()
		$SpeedCooldownTimer.start()
		item_used.emit($SpeedCooldownTimer.time_left)


func _on_speed_item_timer_timeout():
	player.speed = player.speed / speed_boost
