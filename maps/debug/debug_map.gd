extends Node3D

@onready var rng = RandomNumberGenerator.new()

const AMOUNT = 12
const AMOUNT_X = 5

func _on_gadget_interacted() -> void:
	if !Reporter.camera_axis.frozen:
		Reporter.camera_axis.freeze_camera(Vector3(0, 0, 4.0))
	else: Reporter.camera_axis.unfreeze_camera()
	
	var _e = ProjectileEvent.new()
	add_child(_e)
	_e.play({ "type": "test" })
