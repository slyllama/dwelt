@icon("res://generic/icons/Shard.svg")
class_name Shard extends Node3D

@export var quest_sequence: Array[String]
@export var quest_data: Dictionary[String, Quest]

const SHARD := true # just used to identify that this scene is a shard

func _set_bus_vol(vol: float) -> void:
	var _clamped_vol: float = clamp(vol, 0.0, 1.0)
	AudioServer.set_bus_volume_linear(0, _clamped_vol)

func _ready() -> void:
	_set_bus_vol(0.0)
	
	# Populate save file with a space for this shard's data
	if !$GadgetManager.shard_id in Save.save.shard_data:
		Save.save.shard_data[$GadgetManager.shard_id] = {}
	Dwelt.current_shard_id = $GadgetManager.shard_id
	
	Utils.debug_mode_changed.emit() # update debugging nodes
	
	Utils.debug_sent.connect(func(string: String) -> void:
		if string == "/resetpos":
			$Player.position = Vector3(0.0, 2.0, 3.0)
		elif string == "/debugeffects":
			if !Dwelt.ui_pane_manager.close_pane_by_id("effect_debug_pane"):
				var _edp := load("res://lib/effect/effect_debug_pane/effect_debug_pane.tscn")
				var _effect_debug_pane: UIPane = _edp.instantiate()
				Dwelt.ui_pane_manager.add_child(_effect_debug_pane)
				_effect_debug_pane.position = Vector2(32, 42))
	
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
	# Skip full screen checks if the game has been run once
	for _i in 3: await get_tree().process_frame
	Settings.apply_all_settings(false, ["full_screen"])
	var _sound_fade_in := create_tween()
	_sound_fade_in.tween_method(_set_bus_vol, 0.0, float(Settings.settings.volume), 1.0)
	
	# Update visual displays of currencies
	for _currency_id: String in Save.save.currencies:
		Dwelt.currency_updated.emit(_currency_id)
	
	# Look for the latest quest ID in the save; if not there add the first quest and load it
	# TODO: needs more safety
	var _shard_data: Dictionary = Save.save.shard_data[$GadgetManager.shard_id]
	if quest_sequence and quest_data:
		if !"current_quest" in _shard_data:
			_shard_data["current_quest"] = quest_sequence[0]
		Save.quest_changed.emit(quest_data[_shard_data["current_quest"]])
	else:
		Utils.pdebug("No quest data.", "Shard")
		Save.quest_changed.emit(null)
	
	DweltInput.current_device_changed.emit()
	Dwelt.first_run = false
