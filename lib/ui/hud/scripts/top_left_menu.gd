extends HBoxContainer

const DEFAULT_ALPHA = 0.45

func _ready() -> void:
	Utils.debug_mode_changed.connect(func() -> void:
		%DevMenu.visible = Utils.debug_mode)
	
	for _n: Control in get_children():
		if _n is Button:
			_n.pressed.connect(Dwelt.click_sound_requested.emit)
		if _n is TextureButton:
			_n.modulate.a = DEFAULT_ALPHA
			_n.mouse_entered.connect(func() -> void: _n.modulate.a = 1.0)
			_n.mouse_exited.connect(func() -> void: _n.modulate.a = DEFAULT_ALPHA)
