extends CharacterBody3D
# Player
# Handles player movement and characteristics

@export var gravity := 160.0
@export var base_speed := 2.6
@export var smoothing := 25.0
@export var jump_strength := 8.0
@export var hover_height := 1.0

@onready var base: CollisionShape3D = get_node("Collision")
@onready var model: Node3D = get_node("Collision/Player")
@onready var sphere_mesh: GeometryInstance3D = get_node("Collision/Player/SpiritArmature/Skeleton3D/InternalBase/InternalBase")

var _speed = base_speed
var _direction = Vector3.ZERO
var _target_velocity = Vector3.ZERO
var _jump_energy = 0.0

var _mesh_y_state = 0.0

# Shorthand to enable and disable shadows on GeometryInstances
func _set_shadow(node: GeometryInstance3D, state: bool) -> void:
	if state == false: node.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	else: node.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON

# Duplicate generic star particles and add them to children
func _add_star(child: Node) -> void:
	var star = $Stars.duplicate()
	star.visible = true
	child.add_child(star)

# Animate the mesh bouncing when it lands on the floor
func _bounce_mesh(delta: float):
	_mesh_y_state = lerp(_mesh_y_state, 0.0, 7 * delta)
	var _adj_mesh_y_state = _mesh_y_state
	if _adj_mesh_y_state > 0.5:
		_adj_mesh_y_state = 1 - _adj_mesh_y_state
	_adj_mesh_y_state *= 2.0
	model.position.y = _adj_mesh_y_state * -0.04

func _ready() -> void:
	$Collision/Player/AnimationPlayer.play("OrbSpin")
	_add_star($Collision/Player/SpiritArmature/Skeleton3D/Orb/Orb)
	_add_star($Collision/Player/SpiritArmature/Skeleton3D/Orb_001/Orb_001)
	_add_star($Collision/Player/SpiritArmature/Skeleton3D/Orb_002/Orb_002)
	
	# Disable all shadows except for the central sphere
	for node in Utilities.get_all_children($Collision/Player):
		if node is GeometryInstance3D:
			_set_shadow(node, false)
	_set_shadow(sphere_mesh, true)
	
	Global.move_player.connect(func(pos: Vector3): global_position = pos)

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
	
	# Slightly slower forward movement when mid-air
	if !is_on_floor(): _speed = base_speed * 0.7
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
	
	# Rotate the model to match movement direction
	if _direction.x > 0 or _direction.z > 0:
		base.rotation_degrees.y = lerp(
			base.rotation_degrees.y, _camera_direction + 180.0, 5.0 * delta)
	_bounce_mesh(delta)

func _on_ground_collided() -> void:
	_mesh_y_state = 1.0
