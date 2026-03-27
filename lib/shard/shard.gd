extends Node3D

func _set_bus_vol(vol: float) -> void:
	AudioServer.set_bus_volume_linear(0, vol)

func _ready() -> void:
	Utils.debug_mode_changed.emit() # update debugging nodes
	
	# TODO: move sound fade in
	var _sound_fade_in := create_tween()
	_sound_fade_in.tween_method(_set_bus_vol, 0.0, 1.0, 1.0)
	
	# Connect settings
	Settings.setting_applied.connect(func(setting: String, value: String) -> void:
		if %Sky.environment:
			if setting == "bloom":
				if value == "true": %Sky.environment.glow_enabled = true
				elif value == "false": %Sky.environment.glow_enabled = false
			elif setting == "colour_grading":
				if value == "true": %Sky.environment.adjustment_enabled = true
				elif value == "false": %Sky.environment.adjustment_enabled = false)
	
	# Apply all settings now that each node has had a chance to load
	await get_tree().process_frame
	Settings.apply_all_settings()
