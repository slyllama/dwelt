extends Node3D
# PlayerMeshHandler
# Handles mesh animations and cosmetic transforms

@onready var model: Node3D = get_node("Player")
@onready var skeleton = get_node("Player/SpiritArmature/Skeleton3D")
@onready var sphere_mesh: GeometryInstance3D = skeleton.get_node("InternalBase/InternalBase")

var _mesh_y_state = 0.0
var _engine_rotate_magnitude = 0.0 # smoothed engine speed

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

func update(get_direction: Vector3, velocity: Vector3, camera_direction: float) -> void:
	var delta = get_process_delta_time()
	
	# Rotate the model to match movement direction
	if get_direction.x > 0 or get_direction.z > 0:
		model.rotation_degrees.y = lerp(
			model.rotation_degrees.y, camera_direction + 180.0, 5.0 * delta)
	model.rotation_degrees.x = lerp(model.rotation_degrees.x, get_direction.x * -10.0, 4 * delta)
	model.rotation_degrees.z = lerp(model.rotation_degrees.z, get_direction.z * -10.0, 4 * delta)
	
	# Adjust the speed of the engine depending on how fast we are going
	_engine_rotate_magnitude = lerp(
		_engine_rotate_magnitude, 0.2 + velocity.length() * 0.75, 7 * delta)
	$Player/PlayerAnim.set("parameters/engine_time_scale/scale", _engine_rotate_magnitude)
	
	Global.player_y_rotation = camera_direction + 180.0
	_bounce_mesh(delta)

func _ready() -> void:
	_add_star(skeleton.get_node("Orb/Orb"))
	_add_star(skeleton.get_node("Orb_001/Orb_001"))
	_add_star(skeleton.get_node("Orb_002/Orb_002"))
	
	# Disable all shadows except for the central sphere
	for node in Utilities.get_all_children($Player):
		if node is GeometryInstance3D:
			_set_shadow(node, false)
	_set_shadow(sphere_mesh, true)
