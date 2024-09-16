extends Node3D
# Map
# Handles map setting-up functions; should be extended.

func _input(_event: InputEvent) -> void:
	# 'Regenerate' the player by moving it to the last activated pylon
	if Input.is_action_just_pressed("debug_key"):
		if Global.active_pylon.id != "none":
			%Player.position = (
				Global.active_pylon.position + Vector3(-0.45, 0, 0))

func _ready() -> void:
	# Retina screen scaling
	if DisplayServer.screen_get_size().x > 2000:
		get_window().size *= 2.0
		get_window().content_scale_factor = 2.0
