extends "res://lib/shard/shard.gd"

@onready var rotator_animators = [
	$PillarRotator/MachinePillar/AnimationPlayer,
	$PillarRotator2/MachinePillar/AnimationPlayer,
	$PillarRotator3/MachinePillar/AnimationPlayer ]

func _ready() -> void:
	super()
	
	# Assign terrain
	$Greybox/Central/StaticBody3D.set_meta("walk_type", "grass")
	$CrystalSpire/Platform/StaticBody3D.set_meta("walk_type", "metal")
	
	$CrystalSpire/Cube.visible = false
	
	# Start animations at a random time
	for _r: AnimationPlayer in rotator_animators:
		_r.seek(randf())
		_r.play("float")
	
	await get_tree().create_timer(1.5).timeout
	$Music.play()
