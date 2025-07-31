extends Control

var main_menu = "res://level/main menu/menu.tscn"

func _ready() -> void:
	$GameOverPanel.visible = false

func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://UI/item_selection_ui.tscn")
	#get_tree().reload_current_scene()

#TODO: Need to stop the player from moving when the timer runs out.
func _on_timer_ui_node_time_is_out():
	$GameOverPanel.visible = true

func _on_main_menu_pressed():
	get_tree().change_scene_to_file(main_menu)

func _on_quit_pressed():
	get_tree().quit()


func _on_finish_line_show_victory():
	pass # Replace with function body.
