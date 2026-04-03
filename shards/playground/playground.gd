extends "res://lib/shard/shard.gd"

func _ready() -> void:
	super()
	
	# Camera squeezes toward the player if it gets pushed up against these meshes
	$Platform/Platform/StaticBody3D.set_collision_layer_value(2, true)
	$Platform/Landscape/StaticBody3D.set_collision_layer_value(2, true)
	
	# Debugging for effects - so I can see them :)
	var _edp := load("res://lib/effect/effect_debug_pane/effect_debug_pane.tscn")
	var _effect_debug_pane: UIPane = _edp.instantiate()
	_effect_debug_pane.position = Vector2(32, 42)
	Dwelt.ui_pane_manager.add_child(_effect_debug_pane)
	
	# NOTE: temporarily enabling debug by default
	Utils.debug_mode = true
	Utils.debug_mode_changed.emit()
