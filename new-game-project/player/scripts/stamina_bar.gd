extends Node2D

#TODO: When ever the player's stamina is negitive, the UI for the stamina will go backwards. Happens rarley but does occur.

var is_vis: bool
var parent 
func _ready():
	parent = get_parent()
	visible = false
	is_vis = false

func _process(delta):
	if parent.stamina < parent.max_stamina:
		bar_change()
	if parent.stamina == parent.max_stamina and is_vis == true:
		bar_fade()

func bar_change():
	modulate.a = 255
	visible = true
	is_vis = true
	$Remaining_bar.scale.x = parent.stamina /100

func bar_fade():
	is_vis = false
	$AnimationPlayer.play("fade_out")
	
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_out":
		visible = false
