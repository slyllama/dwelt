extends CanvasLayer

func _set_abberation(val: float) -> void:
	$Canvas.material.set_shader_parameter("aberration_displacement", val)

func aberrate(time = 0.7) -> void:
	var _aberrate_tween = create_tween()
	_aberrate_tween.tween_method(_set_abberation, 8.0, 0.0, time)

func _ready() -> void:
	# Setup
	$DamageSplash.modulate.a = 0.0
	$Underlay.queue_free()
	
	# Connections
	Reporter.do_shake_camera.connect(aberrate)
	Reporter.do_aberrate_camera.connect(aberrate)
	
	GameHandler.life_lost.connect(func():
		$DamageSplash.modulate.a = 1.0
		var _fade_tween = create_tween()
		_fade_tween.tween_property($DamageSplash, "modulate:a", 0.0, 0.55))
