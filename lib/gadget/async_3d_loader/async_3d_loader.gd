class_name Async3DLoader extends Node3D

@export_file("*.tscn") var path: String

var status: int
var progress: Array[float]
var has_loaded := false
var valid := false

signal loaded

func spawn() -> void:
	var _pscene: PackedScene = ResourceLoader.load_threaded_get(path)
	var _scene := _pscene.instantiate()
	if !_scene is Node3D:
		Utils.pdebug("Failed thread loading of '" + path + "': not Node3D."
			, "Async3DLoader")
		queue_free()
		return
	
	# Apply this nodes 3D properties to the target scene
	_scene.position = position
	_scene.rotation = rotation
	_scene.scale = scale
	
	# Add to parent and free this node
	get_parent().call_deferred("add_child", _scene)
	loaded.emit()
	Utils.pdebug("Completed thread loading of '" + path + "'.", "Async3DLoader")
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
			spawn()
		ResourceLoader.THREAD_LOAD_FAILED:
			Utils.pdebug("Failed thread loading of '" + path + "': THREAD_LOAD_FAILED."
				, "Async3DLoader")
