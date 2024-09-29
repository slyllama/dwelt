extends CanvasLayer
# SmokeTransition
# Animated fancy fade-in

@export var time = 0.6

func _set_value(val) -> void:
	$BG.material.set_shader_parameter("size", 0.7 + val * 0.3)
	$BG.material.set_shader_parameter("exponent", 1 + val * 4)
	$BG.material.set_shader_parameter("darkness", 0.9 - 0.9 * (1 - val))
	$BG.material.set_shader_parameter("overall_alpha", 1 - ease(val, 3.0)) 

func fade_out() -> void:
	var fade_tween = create_tween()
	fade_tween.tween_method(_set_value, 0.0, 1.0, time)
	fade_tween.tween_callback(queue_free)

func _ready() -> void:
	_set_value(0) # initialize
