extends Control

const TARGET_MOD = 0.5

func _ready() -> void:
	modulate.a = 0.0
	
	Global.input_captured.connect(func():
		modulate.a = 0.0
		visible = true
		var _t = create_tween()
		_t.tween_property(self, "modulate:a", TARGET_MOD, 0.1))
	Global.input_uncaptured.connect(func():
		modulate.a = TARGET_MOD
		var _t = create_tween()
		_t.tween_property(self, "modulate:a", 0.0, 0.1)
		_t.tween_callback(func(): if modulate.a == 0.0: visible = false))
