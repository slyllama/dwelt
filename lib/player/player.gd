extends CharacterBody3D
# Player
# Handles player movement and characteristics. Mesh updates are now handled in PlayerMeshHandler.

signal reached_kill_height
var is_kill_height = false
var rng = RandomNumberGenerator.new()
const SummonFX = preload("res://lib/player/summon_fx/summon_fx.tscn")

@export var gravity := 160.0
@export var base_speed := 1.9
@export var smoothing := 25.0
@export var jump_strength := 8.5
@export var kill_height := -10.0

@onready var base: CollisionShape3D = get_node("Collision")

var _speed = base_speed
var _direction = Vector3.ZERO
var _target_velocity = Vector3.ZERO
var _jump_energy = 0.0
var mesh_y_state = 0.0

# Revive the player if it descends below the "kill height"
func revive() -> void:
	Global.move_player.emit(
		Global.active_pylon.position + Vector3(-0.4, 1, 0))
	is_kill_height = false

# Set the original orientation of the player so that there isn't an awkward
# segue to it when the level starts
func set_initial_rotation(camera_rotation: Vector3) -> void:
	# Strip out non-y rotation
	$CameraHandler.rotation_degrees = camera_rotation * Vector3(0, 1, 0)
	$CameraHandler.orbit_handler.set_initial_rotation(
		camera_rotation * Vector3(1, 1, 0)) # never roll the camera

func _ready() -> void:
	CameraData.camera = $CameraHandler.camera
	
	SettingsHandler.setting_changed.connect(func(param):
		if param == "orbit_sensitivity":
			$CameraHandler.calculated_sensitivity = ($CameraHandler.orbit_sensitivity
				* SettingsHandler.settings.orbit_sensitivity * 0.01))
	
	Global.move_player.connect(func(pos: Vector3):
		global_position = pos)
	$GroundDetector.target_position.y = -$Collision.shape.size.y / 2.0 - 0.5
	%Mesh.update(_direction, velocity, $CameraHandler.rotation_degrees.y, true)
	var _s = SummonFX.instantiate()
	add_child(_s)

# Play some mechanical sounds when starting and stopping the vessel
func _input(_event: InputEvent) -> void:
	if !Global.player_can_move: return
	if Input.is_action_just_pressed("move_forward"):
		$GroundDetector/Engage.pitch_scale = 0.9 + randf() * 0.2
		$GroundDetector/Engage.play()
	if Input.is_action_just_released("move_forward"):
		$GroundDetector/Disengage.pitch_scale = 0.8 + randf() * 0.4
		$GroundDetector/Disengage.play()
	
	#TODO: this is debug/presentation only and needs to be removed
	if Input.is_action_just_pressed("ui_home"):
		var _s = SummonFX.instantiate()
		add_child(_s)

func _process(_delta: float) -> void:
	$CameraHandler.mouse_in_ui = Global.mouse_in_ui()
	$CameraHandler.in_exclusive_ui = Global.in_exclusive_ui

func _physics_process(delta: float) -> void:
	# Process inputs
	if Input.is_action_pressed("move_forward"): _direction.x = 1
	elif Input.is_action_pressed("move_back"): _direction.x = -1
	else: _direction.x = 0
	
	if Input.is_action_pressed("move_right"): _direction.z = 1
	elif Input.is_action_pressed("move_left"): _direction.z = -1
	else: _direction.z = 0

	var _camera_direction = $CameraHandler.rotation_degrees.y
	var _camera_basis = $CameraHandler.global_transform.basis
	
	# Slightly faster forward movement when mid-air
	if !is_on_floor(): _speed = base_speed * 1.1
	else: _speed = base_speed
	
	# Multiply inputs by the movement vector and orbit rotation
	# This could be improved, but it works
	_target_velocity = (Vector3.FORWARD * _camera_basis
		* Vector3(-1, 0, 1) * _direction.x)
	_target_velocity += (Vector3.RIGHT * _camera_basis
		* Vector3(1, 0, -1) * _direction.z)
	_target_velocity = _target_velocity.normalized() * _speed
	
	# Apply movement, including gravity and a jump check
	velocity = lerp(velocity, _target_velocity, smoothing * delta)
	if Input.is_action_just_pressed("jump") and is_on_floor():
		_jump_energy = jump_strength
	_jump_energy = lerp(_jump_energy, 0.0, 5.0 * delta)
	if _jump_energy < 1.0: _jump_energy = 0.0
	velocity.y += _jump_energy
	if !is_on_floor(): velocity.y -= gravity * delta
	
	# Change the pitch of the engine depending on how fast it's going, excluding
	# vertical velocity (jumps) - as long as we're not in a cutscene
	var _target_pitch_scale: float = 1.0 + Vector3(velocity * Vector3(1, 0, 1)).length() / base_speed * 0.5
	if Global.in_exclusive_ui: _target_pitch_scale = 1.0
	$GroundDetector/Engine.pitch_scale = lerp($GroundDetector/Engine.pitch_scale, _target_pitch_scale, 0.07)
	
	if Global.player_can_move:
		move_and_slide()
	
	Global.player_position = position
	%Mesh.update(_direction, velocity, _camera_direction) # update mesh
	%Listener.rotation_degrees.y = _camera_direction # use camera for sound direction
	
	if position.y < kill_height:
		if !is_kill_height:
			is_kill_height = true
			revive()

func _on_ground_collided() -> void:
	%Mesh._mesh_y_state = 1.0
