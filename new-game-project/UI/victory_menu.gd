extends Control

func _ready() -> void:
	$VictoryMenuPanel.visible = false

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://level/main menu/menu.tscn")

func _on_retry_pressed():
	get_tree().change_scene_to_file("res://UI/item_selection_ui.tscn")


func _on_finish_line_show_victory():
	$VictoryMenuPanel.visible = true
