@tool
extends "res://lib/map/map.gd"

func _ready() -> void:
	super()
	
	if Engine.is_editor_hint(): return
	# Set custom camera starting rotation
	$Player/CameraHandler._target_rotation.y = 30
	$Player/CameraHandler.rotation_degrees.y = 30
	configure_map({
		"bg_color": Color(0.15, 0.15, 0.15)
	})
	
	SettingsHandler.save_to_file()

func _to_dwellan() -> void:
	Global.change_map("dwellan_island")
