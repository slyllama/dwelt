extends "res://lib/shard/shard.gd"

func _ready() -> void:
	super()
	
	$Greybox/Central/StaticBody3D.set_meta("walk_type", "grass")
