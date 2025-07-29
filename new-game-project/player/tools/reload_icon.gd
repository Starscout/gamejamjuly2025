extends Node2D
var parent
var opaque_screen
func _ready():
	opaque_screen = $"ReloadIconExample-export/ColorRect"
	parent = get_parent() 
	#Parent items need signal that activates when used, passing time (In seconds)
	if parent:
		parent.connect("item_used", Callable(self, "_on_item_used"))

func _on_item_used(duration):
	$AnimationPlayer.speed_scale = 1 * duration
	$AnimationPlayer.play("opaque go down")
		
