extends HBoxContainer
# Settings presets

func _on_low_pressed() -> void:
	DwSettings.apply_setting("bloom", "false", false)
	DwSettings.apply_setting("colour_grading", "true", false)
	DwSettings.apply_setting("shadows", "low", false)
	DwSettings.apply_setting("draw_distance", "low", false)
	DwSettings.apply_setting("volumetric_fog", "false", false)
	DwSettings.apply_setting("taa_anti_aliasing", "false", false)
	DwSettings.apply_all_settings(true, ["full_screen"])
	
	DwSettings.settings_redraw.emit() # update UI buttons status

func _on_medium_pressed() -> void:
	DwSettings.apply_setting("bloom", "true", false)
	DwSettings.apply_setting("colour_grading", "true", false)
	DwSettings.apply_setting("shadows", "medium", false)
	DwSettings.apply_setting("draw_distance", "medium", false)
	DwSettings.apply_setting("volumetric_fog", "true", false)
	DwSettings.apply_setting("taa_anti_aliasing", "true", false)
	DwSettings.apply_all_settings(true, ["full_screen"])
	
	DwSettings.settings_redraw.emit() # update UI buttons status

func _on_high_pressed() -> void:
	DwSettings.apply_setting("bloom", "true", false)
	DwSettings.apply_setting("colour_grading", "true", false)
	DwSettings.apply_setting("shadows", "high", false)
	DwSettings.apply_setting("draw_distance", "high", false)
	DwSettings.apply_setting("volumetric_fog", "true", false)
	DwSettings.apply_setting("taa_anti_aliasing", "true", false)
	DwSettings.apply_all_settings(true, ["full_screen"])
	
	DwSettings.settings_redraw.emit() # update UI buttons status
