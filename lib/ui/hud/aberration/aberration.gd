extends CanvasLayer

func _ready() -> void:
	var animate = create_tween()
	animate.tween_method(func(val):
		$BG.material.set_shader_parameter("intensity", val), 7.0, 0.0, 0.9)
	animate.tween_callback(queue_free)
