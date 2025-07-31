extends Control

@export var the_game = "res://UI/item_selection_ui.tscn" #"res://level/terrain/test_level.tscn" 

#func _ready():
	#$FadeCanvas.transition_in()

func _on_play_pressed():
	$FadeCanvas.transition_out()

func _on_quit_pressed():
	get_tree().quit()


func _on_fade_canvas_transition_done():
	get_tree().change_scene_to_file(the_game)
