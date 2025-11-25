extends Panel

const TARGET_MOD = 1.0
signal menu_button_pressed(id: String)

func appear() -> void:
	modulate.a = 0.0
	visible = true
	var _t = create_tween()
	_t.tween_property(self, "modulate:a", TARGET_MOD, 0.1)

func disappear() -> void:
	modulate.a = TARGET_MOD
	var _t = create_tween()
	_t.tween_property(self, "modulate:a", 0.0, 0.1)
	_t.tween_callback(func(): if modulate.a == 0.0: visible = false)

func _ready() -> void:
	for _n: HUDButton in $MenuBar.get_children():
		_n.pressed.connect(func():
			menu_button_pressed.emit(_n.id))
	
	modulate.a = TARGET_MOD
	
	Global.input_captured.connect(disappear)
	Global.input_uncaptured.connect(appear)
