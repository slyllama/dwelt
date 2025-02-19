@icon("res://generic/textures/icons/icon_foliage_spawner.svg")
@tool
class_name FoliageSpawner extends MultiMeshInstance3D
# FoliageSpawner
# Uses a MultiMeshInstance to render grasses and flowers.

# Useful default
const GRASS = preload("res://maps/lyllian/meshes/_grass.res")
var rng = RandomNumberGenerator.new()
var foliage_count = 0

@export var foliage_mesh: ArrayMesh = GRASS
@export var count := 5
@export var size := 2.0
@export var scatter := 0.2
@export var min_scale := 3.0
@export var max_scale := 5.0
@export_range(0.01, 1.5) var area_scale := 1.0
@export var smooth := true

@export var reload := false:
	set(_value):
		reload = false
		render()
	get: return(reload)
@export_category("Undergrowth")

@export var moss_cover := true:
	set(_value):
		moss_cover = _value
		_render_moss()
	get: return(moss_cover)

@export_range(0.0, 1.0) var moss_albedo_mix := 1.0:
	set(_value):
		moss_albedo_mix = _value
		_render_moss()
	get: return(moss_albedo_mix)

@export_range(1.0, 4.0) var moss_scaling := 1.5:
	set(_value):
		moss_scaling = _value
		_render_moss()
	get: return(moss_scaling)

@export_category("Shader Configuration")
@export var vary_colours := true
@export var colour_1 := Color(0.077, 0.17, 0)
@export var colour_2 := Color(0.4, 0.48, 0)

var active_foliage_mesh: ArrayMesh
var render_distance := 20.0
var render_fade_spread := 2.0

func set_display_distance() -> void:
	#Configure materials to fade away at a certain distance
	var mat: StandardMaterial3D = active_foliage_mesh.surface_get_material(0)
	mat.distance_fade_mode = BaseMaterial3D.DISTANCE_FADE_PIXEL_DITHER
	mat.distance_fade_min_distance = render_distance + render_fade_spread
	mat.distance_fade_max_distance = render_distance

# Moss functions are separated as to allow live undergrowh updating without
# trigging a MeshInstance buffer replacement
func _render_moss() -> void:
	if moss_cover:
		$Moss.visible = true
		$Moss.albedo_mix = moss_albedo_mix
		$Moss.size = Vector3(
			size * moss_scaling, 0.5, size * moss_scaling)
	else: 
		$Moss.visible = false

func render(density: float = 1.0) -> void:
	if foliage_mesh == null: active_foliage_mesh = GRASS
	else: active_foliage_mesh = foliage_mesh
	_render_moss()
	
	# Reset - clear foliage count
	if !Engine.is_editor_hint():
		Global.foliage_count -= foliage_count
	foliage_count = 0
	
	var build_multimesh: Resource = MultiMesh.new()
	if vary_colours: build_multimesh.use_colors = true
	build_multimesh.mesh = active_foliage_mesh
	build_multimesh.transform_format = MultiMesh.TRANSFORM_3D
	build_multimesh.instance_count = count * count
	build_multimesh.visible_instance_count = floor(count * count * density)
	var midpoint = Vector3(size / 2, 0, size / 2)
	var separation = size / count # base distance between instances
	
	for y in count:
		for x in count:
			var i = y * count + x
			if vary_colours:
				build_multimesh.set_instance_color(i, lerp(colour_1, colour_2, rng.randf()))
			
			var base_pos = Vector3(x * separation, 0, y * separation) - midpoint
			var grass_scatter = Vector3(rng.randf() * scatter, 0, rng.randf() * scatter)
			
			
			var _ps = min_scale + rng.randf() * (max_scale - min_scale)
			var grass_scale = Vector3(_ps * area_scale, _ps, _ps * area_scale)
			
			var grass_rotation = rng.randf() * deg_to_rad(360.0)
			
			var dist: float = 1
			if smooth:
				dist = abs(float(x) / count - 0.5) + abs(float(y) / count - 0.5)
				dist = 0.5 + (1 - dist) / 2.0
			
			# Apply transforms
			var grass_transform = Transform3D(Basis(), base_pos)
			grass_transform = grass_transform.scaled_local(grass_scale * Vector3(1.0, dist, 1.0))
			grass_transform = grass_transform.translated_local(grass_scatter)
			grass_transform = grass_transform.rotated_local(Vector3.UP, grass_rotation)
			build_multimesh.set_instance_transform(i, grass_transform)
	
	foliage_count = floor(count * count * density)
	multimesh = build_multimesh
	if !Engine.is_editor_hint():
		set_display_distance()
		Global.foliage_count += foliage_count

func _ready() -> void:
	_render_moss()
	if !Engine.is_editor_hint():
		SettingsHandler.setting_changed.connect(func(parameter):
			if parameter == "particle_density":
				var _value = SettingsHandler.settings.particle_density
				if _value == "low": multimesh.visible_instance_count = floor(count * count * 0.3)
				elif _value == "medium": multimesh.visible_instance_count = floor(count * count * 0.6)
				else: multimesh.visible_instance_count = floor(count * count * 1.0)
		)
		
		$DebugSphere.visible = false

func _process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	# Turn off foliage visiblity after the shader has faded it out
	var dist = global_position.distance_to(Global.player_position)
	if visible: # includes a buffer
		if dist > render_distance + 1.0: visible = false
	else:if dist < render_distance + 1.0: visible = true
