extends Control

@export var the_game = "res://level/terrain/tile_layers.tscn" 

func _on_play_pressed():
	get_tree().change_scene_to_file(the_game)

func _on_quit_pressed():
	get_tree().quit()
