extends Control

func _ready() -> void:
	$GameOverPanel.visible = false
	$GameOverLabel.visible = false

func _on_restart_button_pressed():
	get_tree().reload_current_scene()

#TODO: Need to stop the player from moving when the timer runs out.
func _on_timer_ui_node_time_is_out():
	$GameOverPanel.visible = true
	$GameOverLabel.visible = true
