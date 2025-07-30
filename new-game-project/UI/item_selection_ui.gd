extends Control

#Ah yes, why am I making this UI a child of the player? Technically I could also make it a child of the level but either way---
#Why are these the two ways I am doing it? Well, I can not figure out how to add a scene to a scene that doesn't exist. E.g. if I 
#wanted this to be a menu that pops up before the game starts, I have no idea how to do that. That is what I was trying to do at
#first, but I could not do it. So now, this code needs to be under the player or can be reworked to be a child of the world/level.
#I do not think that to be an elegant solution, but here we are. If one of you two think this needs to be refactored, plsease do
#so, I know this is a sloppy solution. 

signal start

const SPEEDITEM = preload("res://player/tools/speed_item.tscn")
const GRAPPLINGHOOK = preload("res://player/tools/hook_rope.tscn")
const JUMPITEM = preload("res://player/tools/jump_item.tscn")
const STAMINASUP = preload("res://player/tools/no_drain_stamina_item.tscn")

var the_item
var the_game = "res://level/level/level_000.tscn" #"res://level/terrain/test_level.tscn"

func _ready():
	#player = get_parent()
	#Engine.time_scale = 0
	pass

func _on_speed_item_pressed():
	the_item = SPEEDITEM.instantiate()
	game_go()

func _on_grappling_hook_pressed():
	the_item = GRAPPLINGHOOK.instantiate()
	game_go()

func _on_jump_item_pressed():
	the_item = JUMPITEM.instantiate()
	game_go()

func _on_stamina_sup_pressed():
	the_item = STAMINASUP.instantiate()
	game_go()

func game_go():
	GlobalData.the_players_item = the_item
	#Engine.time_scale = 1
	#player.add_child(the_item)
	#queue_free()
	get_tree().change_scene_to_file(the_game)
	start.emit()
	
