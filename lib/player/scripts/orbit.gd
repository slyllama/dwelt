extends Marker3D

@export var view_length := 2.0
@export var view_sensitivity := 0.75
@export var zoom_min := 1.0
@export var zoom_max := 5.0
@export var zoom_increment := 0.1

@onready var target_x_rotation := rotation.x
@onready var target_y_rotation := global_rotation.y
@onready var target_fov: float = $Camera.fov

var vertical_offset := 0.4

func _ready() -> void:
	# Connections
	Dwelt.shake_camera.connect($Camera/CameraAnims.play.bind("shake"))
	
	Dwelt.camera = $Camera
	top_level = true
	$Camera.top_level = true
	
	await get_tree().create_timer(0.1).timeout
	view_length = zoom_max
	target_fov = 55.0

func _input(event: InputEvent) -> void:
	# Handle zoom (if a GUI element isn't being hovered)
	if !get_window().gui_get_hovered_control() or Input.mouse_mode != Input.MOUSE_MODE_VISIBLE:
		if Input.is_action_just_pressed("zoom_in"):
			view_length -= zoom_increment
		if Input.is_action_just_pressed("zoom_out"):
			view_length += zoom_increment
		if event is InputEventPanGesture:
			view_length -= event.delta.y * 0.15

func _physics_process(_delta: float) -> void:
	view_length = clamp(view_length, zoom_min, zoom_max)
	
	# Handle camera view_length
	$SpringArm.spring_length = lerp($SpringArm.spring_length,
		view_length, Utils.crit_plerp(10.0))
	
	# Handle field-of-view
	$Camera.fov = lerp($Camera.fov, target_fov, Utils.crit_plerp(2.0))
	
	# Update positions
	global_position = lerp(global_position,
		get_parent().global_position + Vector3(0, 1, 0) * vertical_offset,
		Utils.crit_plerp(5.0))
	$Camera.global_position = $SpringArm/CameraAnchor.global_position
	$Camera.global_rotation = $SpringArm/CameraAnchor.global_rotation
