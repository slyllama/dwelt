extends MeshInstance3D

func _distort_prop(parameter: String, value: float) -> void:
	get_active_material(0).set_shader_parameter(parameter, value)

func _ready() -> void:
	visible = true
	$Stars.restart()
	$Stars.emitting = true
	Global.shake_camera.emit()
	
	var distort_tween = create_tween()
	distort_tween.tween_method(func(val):
		_distort_prop("circle_position", val)
		_distort_prop("alpha", ease(1.0 - val, -0.2))
	, 0.0, 1.0, 1.0)
	distort_tween.tween_callback(queue_free)
