@tool
extends "res://lib/map/map.gd"
const RippleFX = preload("res://lib/object/ripple_fx/ripple_fx.tscn")

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
	)

func _physics_process(delta: float) -> void:
	$Rune.rotation_degrees.y += 20.0 * delta

func _on_to_launcher_interacted() -> void:
	get_tree().change_scene_to_file("res://lib/launcher/launcher.tscn")
