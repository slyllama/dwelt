@tool
extends "res://lib/map/map.gd"
# TODO: logic for light switching

const RippleFX = preload("res://lib/object/ripple_fx/ripple_fx.tscn")

func _ready() -> void:
	super()
	
	if Engine.is_editor_hint(): return
	# Set custom camera starting rotation
	$Player/CameraHandler._target_rotation.y = 30
	$Player/CameraHandler.rotation_degrees.y = 30
	configure_map({ "image_path": "res://maps/lyllian/textures/map.png", "magnitude": 33.4, "image_scale": 0.75, "image_rotation": 180, "bg_color": Color(0.15, 0.15, 0.15, 1), "offset_x": -38, "offset_y": 8 })
	SettingsHandler.save_to_file()

func _to_dwellan() -> void:
	var r = RippleFX.instantiate()
	r.finished.connect(func():
		Global.change_map("dwellan_island"))
	$Pylon.add_child(r)
