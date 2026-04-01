extends HBoxContainer
# Settings presets

func _on_low_pressed() -> void:
	Settings.apply_setting("bloom", "false", false)
	Settings.apply_setting("colour_grading", "true", false)
	Settings.apply_setting("shadows", "low", false)
	Settings.apply_setting("draw_distance", "low", false)
	Settings.apply_setting("volumetric_fog", "false", false)
	Settings.apply_setting("taa_anti_aliasing", "false", false)
	Settings.apply_all_settings()
	
	Settings.settings_redraw.emit() # update UI buttons status

func _on_medium_pressed() -> void:
	Settings.apply_setting("bloom", "true", false)
	Settings.apply_setting("colour_grading", "true", false)
	Settings.apply_setting("shadows", "medium", false)
	Settings.apply_setting("draw_distance", "medium", false)
	Settings.apply_setting("volumetric_fog", "true", false)
	Settings.apply_setting("taa_anti_aliasing", "true", false)
	Settings.apply_all_settings()
	
	Settings.settings_redraw.emit() # update UI buttons status

func _on_high_pressed() -> void:
	Settings.apply_setting("bloom", "true", false)
	Settings.apply_setting("colour_grading", "true", false)
	Settings.apply_setting("shadows", "high", false)
	Settings.apply_setting("draw_distance", "high", false)
	Settings.apply_setting("volumetric_fog", "true", false)
	Settings.apply_setting("taa_anti_aliasing", "true", false)
	Settings.apply_all_settings()
	
	Settings.settings_redraw.emit() # update UI buttons status
