extends "res://lib/shard/shard.gd"

func _ready() -> void:
	super()
	
	# Camera squeezes toward the player if it gets pushed up against these meshes
	$Platform/Platform/StaticBody3D.set_collision_layer_value(2, true)
	$Platform/Landscape/StaticBody3D.set_collision_layer_value(2, true)
	
	$AnguishedClaw/AnimationPlayer.play("idle")
	$AnguishedClaw2/AnimationPlayer.play("idle")
	$AnguishedClaw2/AnimationPlayer.advance(0.35)
	$AnguishedClaw2/AnimationPlayer.speed_scale = 0.75
	
	# TODO: test claim target
	$Player/RobotMesh/ClaimBeam.target = $BeamTestTarget
