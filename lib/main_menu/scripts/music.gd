extends AudioStreamPlayer

const SONG_PATH := "res://lib/main_menu/sounds/"
const SONGS := [
	"mus_glass_darkly.ogg",
	"mus_interlace.ogg"
]

@onready var current_song := SONGS[0]

func rotate_songs() -> void:
	stop()
	var _ind :=  SONGS.find(current_song)
	if _ind < SONGS.size() - 1: _ind += 1
	else: _ind = 0
	
	current_song = SONGS[_ind]
	set_stream(load(SONG_PATH + SONGS[_ind]))
	play()

func _ready() -> void:
	await get_tree().create_timer(0.4).timeout
	set_stream(load(SONG_PATH + SONGS[0]))
	play()

func _on_finished() -> void:
	await get_tree().create_timer(3.0).timeout
	rotate_songs()
