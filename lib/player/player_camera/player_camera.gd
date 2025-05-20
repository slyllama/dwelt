class_name DweltCamera extends Node3D
# PlayerCamera
# Camera controls and rotation

@export var track_object = false
@export var track_target = null

@onready var target_zoom_distance = $Axis/Camera.position.z
@onready var target_position = Reporter.player_position
@onready var target_roll = $Axis.rotation_degrees.x

var frozen = false

func freeze_camera(hold_position: Vector3) -> void:
	frozen = true
	target_position = hold_position
	target_zoom_distance = 9.0
	target_roll = -90.0

func unfreeze_camera() -> void:
	frozen = false
	target_position = Reporter.player_position
	target_zoom_distance = 5.0
	target_roll = -60.0
func _ready() -> void:
	Reporter.do_shake_camera.connect(func(): $Anim.play("shake"))
	Reporter.player.focus_mode_entered.connect(func(): target_zoom_distance -= 0.1)
	Reporter.player.focus_mode_exited.connect(func(): target_zoom_distance += 0.1)
	
	unfreeze_camera()
	Reporter.camera_axis = self
	Reporter.camera = $Axis/Camera # assign camera to Reporter

func _process(_delta: float) -> void:
	if !frozen: target_position = Reporter.player_position
	position = lerp(position, target_position, Utils.crit_lerp(20.0))
	
	# Update roll
	$Axis.rotation_degrees.x = lerp(
		$Axis.rotation_degrees.x, target_roll, Utils.crit_lerp(6.0))
	
	$Axis/Camera.position.z = lerp(
		$Axis/Camera.position.z, target_zoom_distance,
		Utils.crit_lerp(6.0))
