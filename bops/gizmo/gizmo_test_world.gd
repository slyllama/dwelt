extends Node3D

func _physics_process(delta: float) -> void:
	# Movement test
	if Input.is_action_pressed("move_left"):
		$Orbit.rotation.y += delta
	elif Input.is_action_pressed("move_right"):
		$Orbit.rotation.y -= delta
