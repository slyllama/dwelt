extends Node3D

var move_vol := 0.0
var _actual_move_sound_volume := 0.0
var _voice_index := [] # used for drawing from a pool of all emotions

const VOICE_PATH = "res://lib/player/sounds/voice/"
const VOICES = {
	"neutral": [
		preload(VOICE_PATH + "neutral_1.ogg"),
		preload(VOICE_PATH + "neutral_2.ogg") ],
	"mischevious": [
		preload(VOICE_PATH + "mischevious_1.ogg"),
		preload(VOICE_PATH + "mischevious_2.ogg"),
		preload(VOICE_PATH + "mischevious_3.ogg"), ]}

# Plays a random voice out of all possible emotions, using _voice_index
func _play_random_voice() -> AudioStreamOggVorbis:
	var _r := randi_range(0, _voice_index.size() - 1)
	var _rolled_type: String = _voice_index[_r]
	var _c := _r
	while _voice_index[_c] == _voice_index[_r]:
		_c -= 1
	var _idx := _r - _c - 1
	return(VOICES[_rolled_type][_idx])

func play_voice(emotion := "all") -> void:
	$Voice.pitch_scale = randf_range(0.95, 1.2)
	if emotion == "all":
		$Voice.stream = _play_random_voice()
	else:
		var _idx := randi_range(0, VOICES[emotion].size() - 1)
		$Voice.stream = VOICES[emotion][_idx]
	$Voice.play()

func _generate_voice_index() -> void:
	for _v: String in VOICES:
		for _s: int in VOICES[_v].size():
			_voice_index.append(_v)

#func _init() -> void:
	#Dwelt.play_voice.connect(play_voice)

func _ready() -> void:
	Utils.debug_sent.connect(func(string: String) -> void:
		if string == "/playvoice":
			play_voice())
	
	_generate_voice_index()

func _process(_delta: float) -> void:
	# Apply movement sound
	_actual_move_sound_volume = lerp(
		_actual_move_sound_volume,
		move_vol, Utils.crit_lerp(12.0))
	$EngineMoving.volume_linear = _actual_move_sound_volume
