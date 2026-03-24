class_name Trail3D extends MeshInstance3D

var points: Array[Vector3] = []
var widths: Array = []
var life_points: Array[float] = []
var og_pos: Vector3

@export var enabled: bool = true
@export var from := 0.5
@export var to := 0.0
@export_range(0.5, 1.5) var acceleration := 1.0
@export var motion_delta := 0.1
@export var lifespan := 1.0
@export var start_color := Color(1.0, 1.0, 1.0, 1.0)
@export var end_color := Color(1.0, 1.0, 1.0, 0.0)

func _ready() -> void:
	og_pos = get_global_transform().origin
	mesh = ImmediateMesh.new()
	enabled = true

func _process(delta: float) -> void:
	var _origin := get_global_transform().origin
	if (og_pos - _origin).length() > motion_delta and enabled:
		append()
		og_pos = _origin
	var p: int = 0
	var max_points: int = points.size()
	while p < max_points:
		life_points[p] += delta
		if life_points[p] > lifespan:
			remove(p)
			p -= 1
			if (p < 0): p = 0
		max_points = points.size()
		p += 1
	mesh.clear_surfaces()
	if points.size() < 2:
		return
	mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)

	for i in range(points.size()):
		var t: float = float(i) / (points.size() - 1.0)
		var color: Color = end_color
		var progress: float = t
		color = start_color.lerp(end_color, 1 - progress)
		mesh.surface_set_color(color)
		var width: Vector3 = widths[i][0] - pow(1 - t, acceleration) * widths[i][1]
		var t0: float = motion_delta * i
		var t1: float = motion_delta * (i + 1)
		mesh.surface_set_uv(Vector2(t0, 0))
		mesh.surface_set_uv(Vector2(t1, 1))
		mesh.surface_add_vertex(to_local(points[i] + width))
		mesh.surface_add_vertex(to_local(points[i] - width))
	mesh.surface_end()

func append() -> void:
	var direction: Vector3 = get_global_transform().origin - og_pos
	var _basis := get_global_transform().basis
	direction = direction.normalized()
	rotation.y = atan2(direction.x, direction.z)
	points.append(get_global_transform().origin)
	widths.append([
		_basis.x * from,
		_basis.x * from - _basis.x * to])
	life_points.append(0.0)

func remove(_i: int) -> void:
	points.remove_at(_i)
	widths.remove_at(_i)
	life_points.remove_at(_i)
