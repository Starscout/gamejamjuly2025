extends CanvasLayer

signal transition_done

@onready var color = $FadeColor
@onready var ani_player = $FadeColor/FadeAnimationPlayer

#func _ready():
	#$FadeColor.visible = false


func _on_fade_animation_player_animation_finished(anim_name):
	if anim_name == "fade_out":
		transition_done.emit()
	
	#if ani_player == "fade_in":
		#color.visible = false
#
func transition_out():
	$FadeColor.visible = true
	ani_player.play("fade_out")
func transition_in():
	$FadeColor.visible = true
	ani_player.play("fade_in")
