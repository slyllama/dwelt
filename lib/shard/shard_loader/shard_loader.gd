@icon("res://generic/icons/ShardLoader.svg")
extends CanvasLayer

const TARGET_SCENE = "res://shards/acidfields/acidfields.tscn"
var target_scene := TARGET_SCENE

var status: int
var progress: Array[float]
var has_loaded := false
var transitioning := false

func _transition() -> void:
	if transitioning: return
	transitioning = true
	Utils.pdebug("Done.", "ShardLoader")
	
	%Black.visible = true
	var _t := create_tween()
	_t.tween_property(%Black, "self_modulate:a", 1.0, 0.3)
	await _t.finished
	get_tree().change_scene_to_packed(
		ResourceLoader.load_threaded_get(target_scene))

func _ready() -> void:
	AudioServer.set_bus_volume_linear(0, 0.0)
	
	if !Save.save_exists():
		Save.new_file_from_default()
	Save.load_file()
	Save.save_file()
	
	DiscordRPC.details = ""
	DiscordRPC.refresh()
	
	target_scene = Dwelt.shard_path_to_load
	Utils.pdebug("Loading shard '" + target_scene + "'...", "ShardLoader")
	ResourceLoader.load_threaded_request(target_scene)

func _physics_process(delta: float) -> void:
	%CogL.rotation += delta * 2.0
	%CogR.rotation -= delta * 4.0

func _process(_delta: float) -> void:
	status = ResourceLoader.load_threaded_get_status(target_scene, progress)
	match status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			%ProgressBar.value = progress[0] * 200.0
		ResourceLoader.THREAD_LOAD_LOADED: _transition()
		ResourceLoader.THREAD_LOAD_FAILED: pass
