extends Node2D

signal show_victory

func _on_finish_line_area_body_entered(body):
	GlobalData.the_level_number += 1
	show_victory.emit()
