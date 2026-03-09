extends CharacterBody3D

func _ready() -> void:
	$RobotMesh/AnimationPlayer.play("idle")
