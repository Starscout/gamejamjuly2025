extends Node2D

@export var speed_boost:float = 2
var player


func _ready():
	player = get_parent()

func _physics_process(delta):
	if Input.is_action_pressed("activate_tool") and $SpeedItemTimer.time_left == 0:
		player.speed = player.speed * speed_boost
		$SpeedItemTimer.start()


func _on_speed_item_timer_timeout():
	player.speed = player.speed / speed_boost
