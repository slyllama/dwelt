extends CharacterBody3D
# Player
# Handles player movement and characteristics. Mesh updates are now handled in PlayerMeshHandler.

signal reached_kill_height
var is_kill_height = false

@export var gravity := 160.0
@export var base_speed := 2.6
@export var smoothing := 25.0
@export var jump_strength := 8.0
@export var hover_height := 1.0
@export var kill_height := -3.0

@onready var base: CollisionShape3D = get_node("Collision")

var _speed = base_speed
var _direction = Vector3.ZERO
var _target_velocity = Vector3.ZERO
var _jump_energy = 0.0
var mesh_y_state = 0.0

# Revive the player if it descends below the "kill height"
func revive():
	Global.move_player.emit(
		Global.active_pylon.position + Vector3(-0.4, 1, 0))
	is_kill_height = false

func _ready() -> void:
	Global.move_player.connect(func(pos: Vector3):
		global_position = pos)

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

func _on_hitbox_entered(area: Area3D) -> void:
	if area is Bullet:
		Global.shake_camera.emit()
		area.hit_player.emit()
		Global.lose_health(30)
