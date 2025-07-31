extends Node

var the_players_item
var the_level_number:int = 0
var victory = false

func _physics_process(delta):
	if the_level_number == 3:
		the_level_number = 0
