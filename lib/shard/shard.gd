extends Node3D

func _set_bus_vol(vol: float) -> void:
	AudioServer.set_bus_volume_linear(0, vol)

func _ready() -> void:
	# TODO: move sound fade in
	
	var _sound_fade_in := create_tween()
	_sound_fade_in.tween_method(_set_bus_vol, 0.0, 1.0, 1.0)
