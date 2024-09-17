@tool
extends Marker3D

const GRASS = preload("res://maps/dwellan_island/props/foliage/grass.res")
var rng = RandomNumberGenerator.new()
var foliage_count = 0

@export var count_root: int = 5:
	get: return(count_root)
	set(value):
		count_root = value
		_ready()

@export var spread: float = 0.15:
	get: return(spread)
	set(value):
		spread = value
		_ready()

@export var min_scale: float = 1.0:
	get: return(min_scale)
	set(value):
		min_scale = value
		_ready()

@export var max_scale: float = 3.0:
	get: return(max_scale)
	set(value):
		max_scale = value
		_ready()

@export var scatter: float = 0.5:
	get: return(scatter)
	set(value):
		scatter = value
		_ready()

func _ready() -> void:
	if !Engine.is_editor_hint():
		Global.foliage_count -= foliage_count
	foliage_count = 0
	for object: Node in get_children():
		object.queue_free()

	var multimesh_instance = MultiMeshInstance3D.new()
	multimesh_instance.multimesh = MultiMesh.new()
	multimesh_instance.cast_shadow = false
	add_child(multimesh_instance)
	
	multimesh_instance.multimesh.mesh = GRASS
	multimesh_instance.multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh_instance.multimesh.instance_count = count_root * count_root
	multimesh_instance.multimesh.visible_instance_count = count_root * count_root
	
	for y in count_root:
		for x in count_root:
			foliage_count += 1
			var i = y * count_root + x
			var pos = Vector2(
				x * spread - count_root * spread / 2.0,
				y * spread - count_root * spread / 2.0)
			multimesh_instance.multimesh.set_instance_transform(i, Transform3D(Basis() * (min_scale + rng.randf() * (max_scale - min_scale)),
				Vector3(pos.x, 0.1, y * spread)).translated_local(rng.randf() * Vector3(scatter, 0.0, scatter)).rotated_local(Vector3.UP, rng.randf() * deg_to_rad(360.0)))
	
	if !Engine.is_editor_hint():
		Global.foliage_count += foliage_count
