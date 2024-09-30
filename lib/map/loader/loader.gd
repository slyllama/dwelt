extends CanvasLayer
# Loader
# Facilitates in loading scenes

const target_scene = "res://maps/dwellan_island/dwellan_island.tscn"

var loading_status: int
var progress: Array[float]
var load_bar_bias = 2.0 # only seems to go to 50% by default

# Change scene after fading everything out
func _transition():
	var fg: ColorRect = $BG.duplicate()
	fg.self_modulate.a = 0.0
	fg.z_index = 99
	add_child(fg)
	
	var fade = create_tween()
	fade.tween_property(fg, "self_modulate:a", 1.0, 0.9)
	var scale_spinner = create_tween()
	scale_spinner.tween_property($Spinner, "scale", Vector2(3.0, 3.0), 0.9)
	fade.tween_callback(func():
		get_tree().change_scene_to_packed(
			ResourceLoader.load_threaded_get(target_scene)))

func _center_cog() -> void:
	# Centralise the spinner (which is a sprite, and not a control node)
	$Spinner.position = get_window().size / 2.0 + Vector2(0, -50.0)

func _ready() -> void:
	AudioServer.set_bus_volume_db(0, -80)
	_center_cog()
	
	# Retina screen scaling
	if DisplayServer.screen_get_size().x > 2000:
		get_window().size *= 2.0
		get_window().content_scale_factor = 2.0
	ResourceLoader.load_threaded_request(target_scene)
	get_window().size_changed.connect(_center_cog)

func _process(delta: float) -> void:
	$Spinner.rotation_degrees += delta * 120.0 # continuous spinning of cog
	loading_status = ResourceLoader.load_threaded_get_status(target_scene, progress)
	
	match loading_status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			$BarBG/Bar.value = lerp(
				$BarBG/Bar.value, progress[0] * 100.0 * load_bar_bias, 0.1)
		ResourceLoader.THREAD_LOAD_LOADED: _transition()
		ResourceLoader.THREAD_LOAD_FAILED: pass
