extends Control

func _ready():
	$RichTextLabel/TextAnimationPlayer.play("scroll_in")
	$ContinueText/ContinueAnimationPlayer.play("continue_fade")

func _physics_process(delta):
	if Input.is_action_pressed("jump"):
		$FadeCanvas.transition_out()


func _on_fade_canvas_transition_done():
	get_tree().change_scene_to_file("res://level/main menu/menu.tscn")
