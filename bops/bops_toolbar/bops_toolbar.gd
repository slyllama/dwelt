extends PanelContainer

func _ready() -> void:
	BOps.mode_changed.connect(func() -> void:
		if BOps.mode == BOps.Mode.INACTIVE:
			visible = false
		else: visible = true)
	
	visible = false
