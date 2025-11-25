extends "res://lib/shard/shard.gd"

@onready var rotator_animators = [
	$CSRotator/CrystalSpire/AnimationPlayer,
	$CSRotator3/CrystalSpire/AnimationPlayer,
	$CSRotator4/CrystalSpire/AnimationPlayer ]

func _ready() -> void:
	super()
	
	# Assign terrain
	$Greybox/Central/StaticBody3D.set_meta("walk_type", "grass")
	$CSRotator2/CrystalSpire/Platform/StaticBody3D.set_meta("walk_type", "metal")
	
	$CSRotator2/CrystalSpire/Cube.visible = false
	
	# Start animations at a random time
	for _r: AnimationPlayer in rotator_animators:
		_r.seek(randf())
		_r.play("float")
	
	#await get_tree().create_timer(1.5).timeout
	#$Music.play()
