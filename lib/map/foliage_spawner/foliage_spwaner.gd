@tool
class_name FoliageSpawner extends MultiMeshInstance3D
# FoliageSpawner
# Uses a MultiMeshInstance to render grasses and flowers.

# Useful default
const GRASS = preload("res://maps/dwellan_island/props/foliage/grass.res")
var rng = RandomNumberGenerator.new()
var foliage_count = 0

@export var foliage_mesh = GRASS
@export var count = 5
@export var size = 2.0
@export var scatter = 0.2
@export var min_scale = 3.0
@export var max_scale = 5.0
@export var smooth = true
@export var moss_cover = true

var active_foliage_mesh: ArrayMesh

@export var reload = false:
	set(_value):
		reload = false
		render()
	get: return(reload)

func render() -> void:
	if foliage_mesh == null: active_foliage_mesh = GRASS
	else: active_foliage_mesh = foliage_mesh
	
	if moss_cover: $Moss.size = Vector3(size * 1.8, 0.5, size * 1.8)
	else: $Moss.visible = false
	
	# Reset - clear foliage count
	if !Engine.is_editor_hint():
		Global.foliage_count -= foliage_count
	foliage_count = 0
	
	multimesh = MultiMesh.new()
	multimesh.mesh = active_foliage_mesh
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.instance_count = count * count
	multimesh.visible_instance_count = count * count
	
	var midpoint = Vector3(size / 2, 0, size / 2)
	var separation = size / count # base distance between instances
	
	for y in count:
		for x in count:
			var i = y * count + x

			var base_pos = Vector3(x * separation, 0, y * separation) - midpoint
			var grass_scatter = Vector3(rng.randf() * scatter, 0, rng.randf() * scatter)
			var grass_scale = Vector3(
				max_scale, min_scale + rng.randf() * (max_scale - min_scale), max_scale)
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
			multimesh.set_instance_transform(i, grass_transform)
			
			foliage_count += 1
	
	if !Engine.is_editor_hint():
		Global.foliage_count += foliage_count

func _ready() -> void:
	render()
