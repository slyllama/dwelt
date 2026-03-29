extends HBoxContainer

const DEFAULT_ALPHA = 0.45

func _ready() -> void:
	for _n: Control in get_children():
		_n.modulate.a = DEFAULT_ALPHA
		_n.mouse_entered.connect(func() -> void: _n.modulate.a = 1.0)
		_n.mouse_exited.connect(func() -> void: _n.modulate.a = DEFAULT_ALPHA)
