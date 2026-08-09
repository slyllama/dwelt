extends AudioStreamPlayer

@export_file_path("*.ogg") var track_list: Array[String] = []
@export var track_gap := 4.0
@export var ready_delay := 1.0

@onready var current_song: String

func rotate_songs() -> void:
	stop()
	var _ind :=  track_list.find(current_song)
	if _ind < track_list.size() - 1: _ind += 1
	else: _ind = 0
	
	current_song = track_list[_ind]
	set_stream(load(track_list[_ind]))
	play()

func _ready() -> void:
	DwSettings.setting_applied.connect(func(setting: String, value: String) -> void:
		if setting == "music_volume":
			var _clamped_vol: float = clamp(float(value), 0.0, 1.0)
			DwGlobal.music_volume = _clamped_vol
			volume_linear = _clamped_vol)
			
	if track_list.size() > 0: current_song = track_list[0]
	else: return
	
	await get_tree().create_timer(ready_delay).timeout
	set_stream(load(track_list[0]))
	play()

func _process(_delta: float) -> void:
	# We know that the slider is only being dragged when the left mouse button
	# is down, so we only update volume when this input is happening
	# TODO: further reduce volume checks (ideally only when the slider is being dragged)
	if Input.is_action_pressed("left_click"):
		volume_linear = DwGlobal.music_volume

func _on_finished() -> void:
	await get_tree().create_timer(track_gap).timeout
	rotate_songs()
