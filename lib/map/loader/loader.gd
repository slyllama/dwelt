extends CanvasLayer
# Loader
# Facilitates in loading scenes

const target_scene = "res://maps/dwellan_island/dwellan_island.tscn"

var loading_status: int
var progress: Array[float]
var load_bar_bias = 2.0 # only seems to go to 50% by default

func _ready() -> void:
	AudioServer.set_bus_volume_db(0, -80)
	# Retina screen scaling
	if DisplayServer.screen_get_size().x > 2000:
		get_window().size *= 2.0
		get_window().content_scale_factor = 2.0
	ResourceLoader.load_threaded_request(target_scene)

func _process(_delta: float) -> void:
	loading_status = ResourceLoader.load_threaded_get_status(target_scene, progress)
	
	match loading_status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			$BarBG/Bar.value = lerp(
				$BarBG/Bar.value, progress[0] * 100.0 * load_bar_bias, 0.1)
		ResourceLoader.THREAD_LOAD_LOADED:
			get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(target_scene))
		ResourceLoader.THREAD_LOAD_FAILED:
			print("Error!")
