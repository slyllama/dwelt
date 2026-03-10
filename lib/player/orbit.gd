extends Marker3D

@export var zoom_increment := 0.5
@export var zoom_min := 5.0
@export var zoom_max := 10.0

@onready var target_camera_rotation: float = rotation.y
@onready var target_zoom: float = $Camera.position.z

func _ready() -> void:
	Dwelt.camera = $Camera
	Utils.pdebug("Use Q and E to rotate the camera.", "Player/Orbit")

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("zoom_in"):
		target_zoom -= zoom_increment
	elif Input.is_action_just_pressed("zoom_out"):
		target_zoom += zoom_increment

func _physics_process(_delta: float) -> void:
	target_zoom = clamp(target_zoom, zoom_min, zoom_max)
	target_camera_rotation += $InputHandler.camera_rotate_input * -0.05
	
	$Camera.position.z = lerp(
		$Camera.position.z, target_zoom, Utils.crit_plerp(6.0))
	rotation.y = lerp(
		rotation.y, target_camera_rotation, Utils.crit_plerp(10.0))
