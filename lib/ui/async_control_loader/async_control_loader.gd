class_name AsyncControlLoader extends Node
# Loads the specified scene and adds it to the target asynchronously,
# provided both are Controls.

@export_file_path("*.tscn") var source_scene: String
@export var target_scene: Control

var status: int
var progress: Array[float]
var has_loaded := false
var valid := false
var scene: Control

func load_scene() -> void:
	var _pscene: PackedScene = ResourceLoader.load_threaded_get(source_scene)
	scene = _pscene.instantiate()
	var _new_scene := scene.duplicate()
	target_scene.call_deferred("add_child", _new_scene)
	DwUtils.pdebug("Completed thread loading of '" + source_scene + "'.", "ControlAsyncLoader")
	
	close()

func close() -> void:
	scene.queue_free()
	queue_free()

func _ready() -> void:
	if !source_scene: queue_free()
	ResourceLoader.load_threaded_request(source_scene)
	valid = true

func _process(_delta: float) -> void:
	if !valid: return
	status = ResourceLoader.load_threaded_get_status(source_scene, progress)
	match status:
		ResourceLoader.THREAD_LOAD_LOADED:
			has_loaded = true
			if !has_loaded: return
			load_scene()
		ResourceLoader.THREAD_LOAD_FAILED:
			DwUtils.pdebug("Failed thread loading of '" + source_scene + "': THREAD_LOAD_FAILED.",
				"ControlAsyncLoader")
			queue_free()
