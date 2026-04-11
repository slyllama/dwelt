extends "res://lib/shard/shard.gd"

func _ready() -> void:
	super()
	
	# Camera squeezes toward the player if it gets pushed up against these meshes
	$Platform/Platform/StaticBody3D.set_collision_layer_value(2, true)
	$Platform/Landscape/StaticBody3D.set_collision_layer_value(2, true)
	
	# NOTE: temporarily enabling debug by default
	Utils.debug_mode = true
	Utils.debug_mode_changed.emit()
