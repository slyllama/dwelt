class_name Async3DLoader extends Node3D

@export_file("*.tscn") var path: String

var status: int
var progress: Array[float]
var has_loaded := false
var valid := false
var scene: Node3D

signal loaded()

func add_scene(scene_position: Vector3, scene_rotation: Vector3, scene_scale: Vector3) -> void:
	if !has_loaded: return
	scene.position = scene_position
	scene.rotation = scene_rotation
	scene.scale = scene_scale
	get_parent().call_deferred("add_child", scene.duplicate())

func load_scene() -> void:
	var _pscene: PackedScene = ResourceLoader.load_threaded_get(path)
	scene = _pscene.instantiate()
	loaded.emit()
	#Utils.pdebug("Completed thread loading of '" + path + "'.", "Async3DLoader")

func close() -> void:
	scene.queue_free()
	queue_free()

func _ready() -> void:
	if !path: queue_free()
	ResourceLoader.load_threaded_request(path)
	valid = true

func _process(_delta: float) -> void:
	if !valid: return
	status = ResourceLoader.load_threaded_get_status(path, progress)
	match status:
		ResourceLoader.THREAD_LOAD_LOADED:
			has_loaded = true
			if !has_loaded: return # can't attempt more than once
			# The Async3DLoader no longer immediately spawns its scene - it holds
			# it in memory, allowing it to be repeatedly duplicated with `add_scene`
			load_scene()
		ResourceLoader.THREAD_LOAD_FAILED:
			Utils.pdebug("Failed thread loading of '" + path + "': THREAD_LOAD_FAILED.",
				"Async3DLoader")
