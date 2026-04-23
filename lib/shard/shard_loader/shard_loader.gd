@icon("res://generic/icons/ShardLoader.svg")
extends CanvasLayer

const TARGET_SCENE = "res://shards/acidfields/acidfields.tscn"
var target_scene := TARGET_SCENE

var status: int
var started := false
var progress: Array[float]
var has_loaded := false
var transitioning := false

func _transition() -> void:
	if transitioning: return
	transitioning = true
	Utils.pdebug("Done.", "ShardLoader")
	get_tree().change_scene_to_packed(
		ResourceLoader.load_threaded_get(target_scene))

func _input(event: InputEvent) -> void:
	if started: return
	if event is InputEventKey:
		if Input.is_action_just_pressed("toggle_debug_mode"):
			target_scene = "res://shards/debug/debug.tscn"
		Utils.pdebug("Loading shard '" + target_scene + "'...", "ShardLoader")
		ResourceLoader.load_threaded_request(target_scene)
		$CogAnchor.visible = true
		started = true

func _physics_process(delta: float) -> void:
	%CogL.rotation += delta * 2.0
	%CogR.rotation -= delta * 4.0

func _process(_delta: float) -> void:
	status = ResourceLoader.load_threaded_get_status(target_scene, progress)
	match status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			$ProgressBar.value = progress[0] * 200.0
		ResourceLoader.THREAD_LOAD_LOADED: _transition()
		ResourceLoader.THREAD_LOAD_FAILED: pass
