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
				var c = load("res://lib/cutscene_instance/cutscene_instance.tscn").instantiate()
				add_child(c)
	)

func _on_to_launcher_interacted() -> void:
	get_tree().change_scene_to_file("res://lib/launcher/launcher.tscn")
