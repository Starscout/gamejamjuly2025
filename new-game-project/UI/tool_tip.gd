extends PanelContainer

const OFFSET: Vector2 = Vector2.ONE * 20

func _ready() -> void:
	hide()

func _input(event: InputEvent) -> void:
	if visible and event is InputEventMouseMotion:
		global_position = get_global_mouse_position() + OFFSET

func toggle(on:bool):
	if on:
		show()
	else:
		hide()


#func item_tooltip_popup(slot: Rect2i, item):
	#var mouse_position = get_viewport().get_mouse_position()
	#var correction 
	#var padding = 4
	#
	#if mouse_position.x <= get_viewport_rect().size.x/2:
		#correction =  Vector2i(slot.size.x + padding, 0)
	#else:
		#correction = -Vector2i(%ToolTipText.size.x + padding, 0)
	#
	#%ToolTipText.popup(Rect2i(slot.position + correction, %ToolTipText.size))
#
#func hide_item_tooltip():
	#%ToolTipText.hide()
