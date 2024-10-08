@tool
extends "res://lib/map/map.gd"
const RippleFX = preload("res://lib/object/ripple_fx/ripple_fx.tscn")
const SummonFX = preload("res://lib/player/summon_fx/summon_fx.tscn")

func _ready() -> void:
	super()
	if Engine.is_editor_hint(): return
	
	$HUD/VFXTools.open()
	$HUD/VFXTools.button_pressed.connect(func(id):
		match id:
			"ripple":
				var r = RippleFX.instantiate()
				r.position.z = 2.0
				add_child(r)
			"summon":
				var s = SummonFX.instantiate()
				%Player.add_child(s)
			"cutscene":
				var c: CutsceneInstance = load(
					"res://lib/cutscene_instance/cutscene_instance.tscn").instantiate()
				c.dialogue_script = ["This is some test dialogue!"]
				c.camera_rotation_degrees = Vector3(-26.0, 90.0, 0)
				c.camera_original_position = Vector3(-2.1, 2.0, 2)
				c.camera_target_position = Vector3(3.3, 2.0, 1.8)
				c.camera_animation_speed = 4.0
				add_child(c)
				
				get_tree().create_timer(0.6).timeout.connect($Summoner.set_idle)
				get_tree().create_timer(2.0).timeout.connect($Summoner.activate)
			"activate_summoner":
				$Summoner.activate()
	)

func _on_to_launcher_interacted() -> void:
	get_tree().change_scene_to_file("res://lib/launcher/launcher.tscn")
