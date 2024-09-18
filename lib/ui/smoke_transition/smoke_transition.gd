extends CanvasLayer

func _set_value(val) -> void:
	$BG.material.set_shader_parameter("size", 0.5 + val / 2)
	$BG.material.set_shader_parameter("exponent", 1 + val * 4)
	$BG.material.set_shader_parameter("darkness", 0.5 - 0.5 * (1 - val))
	$BG.material.set_shader_parameter("overall_alpha", 1 - ease(val, 3.0)) 

func fade_out(delay = 0.0) -> void:
	if delay < 0.1: return
	else: await get_tree().create_timer(delay).timeout
	
	var fade_tween = create_tween()
	fade_tween.tween_method(_set_value, 0.0, 1.0, 0.6)
	fade_tween.tween_callback(queue_free)

func _ready() -> void:
	_set_value(0.0) # initialize
	fade_out(0.3)
