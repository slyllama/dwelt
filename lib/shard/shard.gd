extends Node3D

@onready var original_player_position: Vector3 = $Player.position

func _set_bus_vol(vol: float) -> void:
	AudioServer.set_bus_volume_linear(0, vol)

func _ready() -> void:
	Utils.debug_mode_changed.emit() # update debugging nodes
	
	# TODO: move sound fade in
	var _sound_fade_in := create_tween()
	_sound_fade_in.tween_method(_set_bus_vol, 0.0, 1.0, 1.0)
	
	Utils.debug_sent.connect(func(string: String) -> void:
		if string == "/resetpos":
			$Player.position = original_player_position)
	
	# Connect settings
	Settings.setting_applied.connect(func(setting: String, value: String) -> void:
		if %Sky.environment:
			if setting == "bloom":
				if value == "true": %Sky.environment.glow_enabled = true
				elif value == "false": %Sky.environment.glow_enabled = false
			elif setting == "colour_grading":
				if value == "true": %Sky.environment.adjustment_enabled = true
				elif value == "false": %Sky.environment.adjustment_enabled = false
			elif setting == "volumetric_fog":
				if value == "true": %Sky.environment.volumetric_fog_enabled = true
				elif value == "false": %Sky.environment.volumetric_fog_enabled = false
		if setting == "shadows":
			if value == "low":
				%Sun.shadow_enabled = true
				%Sun.directional_shadow_mode = DirectionalLight3D.SHADOW_ORTHOGONAL
			elif value == "medium":
				%Sun.shadow_enabled = true
				%Sun.directional_shadow_mode = DirectionalLight3D.SHADOW_PARALLEL_2_SPLITS
			elif value == "high":
				%Sun.shadow_enabled = true
				%Sun.directional_shadow_mode = DirectionalLight3D.SHADOW_PARALLEL_4_SPLITS
			elif value == "off":
				%Sun.shadow_enabled = false
		elif setting == "taa_anti_aliasing":
			if value == "true": get_viewport().use_taa = true
			elif value == "false": get_viewport().use_taa = false)
	
	# Apply all settings now that each node has had a chance to load
	await get_tree().process_frame
	Settings.apply_all_settings()
	
	# Update visual displays of currencies
	for _currency_id: String in Save.save.currencies:
		Dwelt.currency_updated.emit(_currency_id)
