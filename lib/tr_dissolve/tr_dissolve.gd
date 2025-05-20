@tool
class_name TextureRectDissolve extends TextureRect

const CanvasDissolveMat = preload("res://generic/materials/mat_canvas_dissolve.tres")
@onready var mat = CanvasDissolveMat.duplicate()

@export var dissolve_time = 0.2
@export var initial_dissolve_value = 1.0

func _set_dissolve_value(value: float) -> void:
	mat.set_shader_parameter("dissolve_value", value)

func dissolve_in() -> void:
	var _dissolve_tween = create_tween()
	_dissolve_tween.tween_method(_set_dissolve_value, 0.0, 1.0, dissolve_time)

func dissolve_out() -> void:
	var _dissolve_tween = create_tween()
	_dissolve_tween.tween_method(_set_dissolve_value, 1.0, 0.0, dissolve_time)

func _ready() -> void:
	material = mat
	
	if Engine.is_editor_hint(): _set_dissolve_value(1.0)
	else: _set_dissolve_value(initial_dissolve_value)
