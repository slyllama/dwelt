extends Node3D
# PlayerCamera
# Camera controls and rotation

@export var zoom_increment = 0.35
@export var zoom_clamp_near = 1.0
@export var zoom_clamp_far = 20.0

@onready var target_zoom_distance = $Axis/Camera.position.z

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("zoom_in"):
		target_zoom_distance -= zoom_increment
	if Input.is_action_just_pressed("zoom_out"):
		target_zoom_distance += zoom_increment

func _ready() -> void:
	Reporter.do_shake_camera.connect(func(): $Anim.play("shake"))
	Reporter.player.focus_mode_entered.connect(func(): target_zoom_distance -= 0.5)
	Reporter.player.focus_mode_exited.connect(func(): target_zoom_distance += 0.5)
	
	Reporter.camera = $Axis/Camera # assign camera to Reporter

func _process(delta: float) -> void:
	# Clamp zoom distances
	target_zoom_distance = clamp(
		target_zoom_distance, zoom_clamp_near, zoom_clamp_far)

	# Smooth and update camera zoom
	$Axis/Camera.position.z = lerp(
		$Axis/Camera.position.z, target_zoom_distance,
		Utils.crit_lerp(delta, 10.0))
