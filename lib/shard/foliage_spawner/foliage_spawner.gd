@tool
extends MultiMeshInstance3D

var foliage_count = 0

@export_tool_button("Render", "Callable") var render_button = render

@export var foliage_mesh: ArrayMesh
@export var count := 5
@export var density := 1.0
@export var size := 2.0
@export var scatter := 0.2
@export var min_scale := 3.0
@export var max_scale := 5.0
@export var smooth := true

@export_category("Shading")
@export var vary_colours := true
@export var colour_1 := Color("1b3800")
@export var colour_2 := Color(0.639, 0.729, 0)

func render() -> void:
	var build_multimesh: Resource = MultiMesh.new()
	if vary_colours: build_multimesh.use_colors = true
	build_multimesh.mesh = foliage_mesh
	build_multimesh.transform_format = MultiMesh.TRANSFORM_3D
	build_multimesh.instance_count = count * count
	build_multimesh.visible_instance_count = floor(count * count * density)
	var midpoint = Vector3(size / 2, 0, size / 2)
	var separation = size / count
	
	# Generate and shuffle transformations
	var _transforms = []
	for y in count:
		for x in count:
			var base_pos = Vector3(x * separation, 0, y * separation) - midpoint
			var grass_scatter = Vector3(randf() * scatter, 0, randf() * scatter)
			var _ps = min_scale + randf() * (max_scale - min_scale)
			var grass_scale = Vector3(_ps, _ps, _ps)
			var grass_rotation = randf() * deg_to_rad(360.0)
			
			var dist: float = 1
			if smooth:
				dist = abs(float(x) / count - 0.5) + abs(float(y) / count - 0.5)
				dist = 0.5 + (1 - dist) / 2.0
			
			var grass_transform = Transform3D(Basis(), base_pos)
			grass_transform = grass_transform.scaled_local(grass_scale * Vector3(1.0, dist, 1.0))
			grass_transform = grass_transform.translated_local(grass_scatter)
			grass_transform = grass_transform.rotated_local(Vector3.UP, grass_rotation)
			_transforms.append(grass_transform)
	
	_transforms.shuffle()
	
	for y in count:
		for x in count:
			var i = y * count + x
			if vary_colours:
				build_multimesh.set_instance_color(i, lerp(colour_1, colour_2, randf()))
			build_multimesh.set_instance_transform(i, _transforms[i])
	multimesh = build_multimesh

#func set_density(get_density) -> void:
	#if ignore_density_check: density = 1.0
	#else: density = get_density
	#foliage_count = floor(count * count * density)
	#multimesh.visible_instance_count = floor(count * count * density)

func _ready() -> void:
	cast_shadow = SHADOW_CASTING_SETTING_OFF
	set_layer_mask_value(1, 0)
	set_layer_mask_value(2, 1)
