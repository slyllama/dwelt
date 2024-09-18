extends Node3D
# Map
# Handles map setting-up functions; should be extended.

## Moss and ground decals will only be projected onto nodes listed here.
@export var ground_decal_meshes: Array[Node]

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
	
	for base_node in ground_decal_meshes:
		for node in Utilities.get_all_children(base_node):
			if "layers" in node:
				node.set_layer_mask_value(2, true)
