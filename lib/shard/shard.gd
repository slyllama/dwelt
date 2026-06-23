@icon("res://generic/icons/Shard.svg")
class_name Shard extends Node3D

@export var shard_id: String
@export var shard_name: String

const SHARD := true # just used to identify that this scene is a shard

func _set_bus_vol(vol: float) -> void:
	var _clamped_vol: float = clamp(vol, 0.0, 1.0)
	AudioServer.set_bus_volume_linear(0, _clamped_vol)

func _ready() -> void:
	_set_bus_vol(0.0)
	
	DwGlobal.current_shard_id = shard_id
	DwGlobal.discord_update_details(shard_name)
	DwUtils.debug_mode_changed.emit() # update debugging nodes
	
	DwUtils.debug_sent.connect(func(string: String) -> void:
		if string == "/resetpos":
			$Player.position = Vector3(0.0, 2.0, 3.0))
	
	# Connect settings
	DwSettings.setting_applied.connect(func(setting: String, value: String) -> void:
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
	for _i in 3: await get_tree().process_frame
	DwSettings.apply_all_settings(false)
	var _sound_fade_in := create_tween()
	_sound_fade_in.tween_method(_set_bus_vol, 0.0, float(DwSettings.settings.volume), 1.0)
	DwGlobal.first_run = false
