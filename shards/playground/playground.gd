extends "res://lib/shard/shard.gd"

func _ready() -> void:
	super()
	
	# Populate the EffectViewer with the clicked Gadget's effects, if one was clicked
	Dwelt.clicked_collision_object.connect(func(object: CollisionObject3D) -> void:
		if object:
			if object is Gadget:
				%EffectViewer.effect_manager = object.effect_manager
			else: %EffectViewer.effect_manager = null
		else: %EffectViewer.effect_manager = null)
	
	# Camera squeezes toward the player if it gets pushed up against these meshes
	$Platform/Platform/StaticBody3D.set_collision_layer_value(2, true)
	$Platform/Landscape/StaticBody3D.set_collision_layer_value(2, true)
