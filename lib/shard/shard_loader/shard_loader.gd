extends CanvasLayer

const TARGET_SCENE = "res://shards/sandbox/sandbox.tscn"
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
	ResourceLoader.load_threaded_request(target_scene)

func _process(_delta: float) -> void:
	status = ResourceLoader.load_threaded_get_status(target_scene, progress)
	match status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS: pass
		ResourceLoader.THREAD_LOAD_LOADED: _transition()
		ResourceLoader.THREAD_LOAD_FAILED: pass
