@tool
extends "res://lib/map/map.gd"
const RippleFX = preload("res://lib/object/ripple_fx/ripple_fx.tscn")

func _ready() -> void:
	super()
	if Engine.is_editor_hint(): return
	# Set custom camera starting rotation
	$Player.set_initial_rotation(Vector3(-45.0, 60.0, -45.0))
	configure_map({
		#"image_path": "res://maps/lyllian/textures/map.png",
		"magnitude": 50.0,
		"image_scale": 0.75,
		"image_rotation": 180,
		"bg_color": Color(0.15, 0.15, 0.15, 1),
		"offset_x": -38,
		"offset_y": 8 })
	SettingsHandler.save_to_file()
	
	$Environment/ScruffyHouse/c_007.set_collision_layer_value(1, false)
	$Environment/ScruffyHouse/c_007.set_collision_layer_value(2, true)

func _to_dwellan() -> void:
	var r = RippleFX.instantiate()
	r.finished.connect(func():
		Global.change_map("dwellan"))
	$Pylon.add_child(r)

func _on_play_cutscene_interacted() -> void:
	# Cutscene test
	var _cutscene: CutsceneInstance = Cutscene.instantiate()
	_cutscene.camera_rotation_degrees.y = 90.0
	_cutscene.camera_original_position = Vector3(-0.8, 3.2, 0.8)
	_cutscene.camera_target_position = Vector3(-1.9, 3.2, 0.8)
	_cutscene.camera_animation_speed = 6.0
	_cutscene.dialogue_script = [ "The serpentine voice remains silent at the mention of this innocent-looking figure, the muffled rain speaking in her place." ]
	add_child(_cutscene)

func _on_summon_object_interacted() -> void:
	$Summoner.activate()

func _faceless_books_collected() -> void:
	_on_play_cutscene_interacted() # debug
