@tool
class_name FoliageBlanket extends Marker3D
# FoliageBlanket
# Renders clumps of foliage over an area, following the normals of that area

@export_file_path("*.tscn") var foliage_cluster: String
@export_tool_button("Render", "MultiMesh") var render_button := render
@export var size := Vector2i(3, 3)
@export var y_offset := 0.0
@export var spread := 1.0
@export var scatter := 0.1

func spawn_foliage(offset: Vector3) -> void:
	var _from := global_position + offset
	var _to := _from - Vector3(0, 50.0, 0)
	var space_state := get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(_from, _to)
	
	query.collide_with_bodies = true
	query.collision_mask = 11
		
	var intersection := space_state.intersect_ray(query)
	if intersection:
		var _pos: Vector3 = intersection.position
		var _normal: Vector3 = intersection.normal
		var _foliage: FoliageSpawner = load(foliage_cluster).instantiate()
		add_child(_foliage)
		_foliage.global_position = _pos
			
		var _basis := _foliage.global_transform.basis
		_basis.y = _normal
		_basis.x = -_basis.z.cross(_normal)
		_basis = _basis.orthonormalized()
		_foliage.global_transform.basis = _basis
		_foliage.render()
		_foliage.global_position.y += y_offset

func render() -> void:
	if !foliage_cluster: return
	for _n in get_children():
		_n.queue_free()
	
	for _y in size.y:
		for _x in size.x:
			var _offset := Vector3(
				_x * spread - (spread * size.x / 2.0), 0,
				_y * spread - (spread * size.y / 2.0))
			_offset.x += randf_range(-scatter / 2.0, scatter)
			spawn_foliage(_offset)

func _ready() -> void:
	render()
