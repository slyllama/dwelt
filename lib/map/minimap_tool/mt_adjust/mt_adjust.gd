@tool
extends HBoxContainer
# MTAdjust (MinimapToolAdjust)
# Utility for adjusting parameters in the minimap, for testing

@export var title = "Parameter"
@export var increment = 0.1
signal value_changed(value)

func set_value(value):
	$Value.text = str(value)

var _d = 0.0
func _process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	_d += delta
	if _d > 0.06:
		_d = 0
		var v = float($Value.text)
		if $Less.button_pressed:
			$Value.text = str(v - increment)
			value_changed.emit(v - increment)
		if $More.button_pressed:
			$Value.text = str(v + increment)
			value_changed.emit(v + increment)

func _ready() -> void:
	$Title.text = title

func _on_apply_pressed() -> void:
	value_changed.emit(float($Value.text))
