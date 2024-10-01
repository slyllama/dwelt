@tool
extends HBoxContainer
# MTAdjust (MinimapToolAdjust)
# Utility for adjusting parameters in the minimap, for testing

@export var title = "Parameter"
@export var increment := 0.1
@export var minimap_field_id := ""
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
	if minimap_field_id == "" or Engine.is_editor_hint(): return
	
	Global.minimap_refresh.connect(func():
		# Set value, if it exists in the global structure
		if minimap_field_id in Global.minimap_data:
			set_value(Global.minimap_data[minimap_field_id]))
	Global.minimap_refresh.emit()

func _on_apply_pressed() -> void:
	value_changed.emit(float($Value.text))
	Global.minimap_refresh.emit()

func _on_value_changed(value: Variant) -> void:
	if minimap_field_id in Global.minimap_data:
		Global.minimap_data[minimap_field_id] = value
		Global.minimap_refresh.emit()
