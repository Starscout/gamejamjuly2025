extends Button

@onready var tooltip = $ToolTips

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered():
	tooltip.toggle(true)

func _on_mouse_exited():
	tooltip.toggle(false)
