extends "res://lib/map/map.gd"

func _ready() -> void:
	super()
	$SpiritVessel/AnimationPlayer.play("OrbSpin")
