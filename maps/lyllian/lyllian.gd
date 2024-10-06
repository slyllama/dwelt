@tool
extends "res://lib/map/map.gd"
const RippleFX = preload("res://lib/object/ripple_fx/ripple_fx.tscn")
const Cutscene = preload("res://lib/cutscene_instance/cutscene_instance.tscn")

func _ready() -> void:
	super()
	if Engine.is_editor_hint(): return
	# Set custom camera starting rotation
	$Player/CameraHandler._target_rotation.y = 90
	$Player/CameraHandler.rotation_degrees.y = 90
	configure_map({
		#"image_path": "res://maps/lyllian/textures/map.png",
		"magnitude": 50.0,
		"image_scale": 0.75,
		"image_rotation": 180,
		"bg_color": Color(0.15, 0.15, 0.15, 1),
		"offset_x": -38,
		"offset_y": 8 })
	SettingsHandler.save_to_file()

func _to_dwellan() -> void:
	var r = RippleFX.instantiate()
	r.finished.connect(func():
		Global.change_map("dwellan"))
	$Pylon.add_child(r)

func _on_to_launcher_interacted() -> void:
	get_tree().change_scene_to_file("res://lib/launcher/launcher.tscn")

func _on_play_cutscene_interacted() -> void:
	# Cutscene test
	var _cutscene: CutsceneInstance = Cutscene.instantiate()
	_cutscene.camera_rotation_degrees.y = 90.0
	_cutscene.camera_original_position = Vector3(-1.0, 3.2, 0.82)
	_cutscene.camera_target_position.x = -0.35
	_cutscene.dialogue_script = [
		"apricot created this amazing art for me! This is a test of instanced dialogue. Blah blah blah."]
	add_child(_cutscene)
