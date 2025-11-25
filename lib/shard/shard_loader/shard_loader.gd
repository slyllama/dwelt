extends CanvasLayer

@export var load_model_viewer := false

const TARGET_SCENE = "res://shards/sandbox/sandbox.tscn"
const MODEL_VIEWER_SCENE = "res://shards/model_viewer/model_viewer.tscn"

var target_scene = TARGET_SCENE
var status: int
var progress: Array[float]
var has_loaded = false
var transitioning = false

func _transition():
	if transitioning: return
	transitioning = true
	Utils.pdebug("Done.", "ShardLoader")
	get_tree().change_scene_to_packed(
		ResourceLoader.load_threaded_get(target_scene))

func _ready() -> void:
	Utils.pdebug("Loading shard '" + target_scene + "'...", "ShardLoader")
	if load_model_viewer:
		target_scene = MODEL_VIEWER_SCENE
	ResourceLoader.load_threaded_request(target_scene)

func _process(_delta: float) -> void:
	status = ResourceLoader.load_threaded_get_status(target_scene, progress)
	match status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS: pass
		ResourceLoader.THREAD_LOAD_LOADED: _transition()
		ResourceLoader.THREAD_LOAD_FAILED: pass
