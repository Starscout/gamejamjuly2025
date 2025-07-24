extends Control

signal time_is_out


func _physics_process(delta):
	$TimerCanvas/TimerLabel.text = str("Time remaining: ") + str(int($TheOnlyOneTimer.time_left))
	
	if Input.is_action_pressed("debug_stop_timer"):
		$TheOnlyOneTimer.stop()
	if Input.is_action_pressed("debug_start_timer"):
		$TheOnlyOneTimer.start()

func _on_the_only_one_timer_timeout():
	time_is_out.emit()


func _on_item_selection_ui_start():
	$TheOnlyOneTimer.start()
