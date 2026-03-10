@tool
class_name FoliageSpawner extends MultiMeshInstance3D

var foliage_count := 0

@export var count := 5
@export var density := 1.0
@export_tool_button("Render", "MultiMesh") var render_button := render

@export_category("Placement")
@export var size := 5.0
@export var scatter := 0.5
@export var smooth := true
@export var follow_floor := false

@export_category("Instances")
@export var foliage_mesh: ArrayMesh
@export var min_scale := 1.0
@export var max_scale := 1.0
@export var scale_offset := Vector3(1.0, 1.0, 1.0)

@export_category("Shading")
@export var vary_colours := true
@export var colour_1 := Color("1b3800")
@export var colour_2 := Color(0.639, 0.729, 0)

func render() -> void:
	multimesh = null
	if !foliage_mesh: return
	
	var build_multimesh: Resource = MultiMesh.new()
	if vary_colours: build_multimesh.use_colors = true
	build_multimesh.mesh = foliage_mesh
	build_multimesh.transform_format = MultiMesh.TRANSFORM_3D
	build_multimesh.instance_count = count * count
	build_multimesh.visible_instance_count = floor(count * count * density)
	var midpoint := Vector3(size / 2, 0, size / 2)
	var separation := size / count
	
	# Generate and shuffle transformations
	var _transforms := []
	for y in count:
		for x in count:
			var base_pos := Vector3(x * separation, 0, y * separation) - midpoint
			var grass_scatter := Vector3(randf() * scatter, 0, randf() * scatter)
			var _ps := min_scale + randf() * (max_scale - min_scale)
			var grass_scale := _ps * scale_offset
			var grass_rotation := randf() * deg_to_rad(360.0)
			
			var dist: float = 1
			if smooth:
				dist = abs(float(x) / count - 0.5) + abs(float(y) / count - 0.5)
				dist = 0.5 + (1 - dist) / 2.0
			
			var grass_transform := Transform3D(Basis(), base_pos)
			grass_transform = grass_transform.translated_local(grass_scatter)
			if follow_floor:
				var _position: Vector3 = global_position + base_pos + grass_scatter
				var _from := _position + Vector3(0, 10.0, 0)
				var _to := _from + Vector3(0, -20.0, 0)
				var space_state := self.get_world_3d().direct_space_state
				var query := PhysicsRayQueryParameters3D.create(_from, _to)
				query.collision_mask = 0b00000000_00000000_00000000_00000010
				var intersection := space_state.intersect_ray(query)
				if intersection:
					var _cpos: Vector3 = intersection.position
					grass_transform = grass_transform.translated_local(Vector3(0, _cpos.y, 0))
			grass_transform = grass_transform.rotated_local(Vector3.UP, grass_rotation)
			grass_transform = grass_transform.scaled_local(grass_scale * Vector3(1.0, dist, 1.0))
			_transforms.append(grass_transform)
	_transforms.shuffle()
	
	for y in count:
		for x in count:
			var i := y * count + x
			if vary_colours:
				build_multimesh.set_instance_color(i, lerp(colour_1, colour_2, randf()))
			build_multimesh.set_instance_transform(i, _transforms[i])
	multimesh = build_multimesh

func set_density(get_density: float) -> void:
	density = get_density
	foliage_count = floor(count * count * density)
	multimesh.visible_instance_count = floor(count * count * density)

# Note: shader changes are managed in the foliage handler
func set_fade_distance(get_distance: float) -> void:
	visibility_range_end = get_distance + 2.0

func _ready() -> void:
	cast_shadow = SHADOW_CASTING_SETTING_OFF
	set_layer_mask_value(1, 0)
	set_layer_mask_value(2, 1)
	
	if Engine.is_editor_hint(): return
	set_fade_distance(20.0)
