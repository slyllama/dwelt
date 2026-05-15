extends Node

@export var fade_in_time := 0.6
@export var fade_out_time := 2.0
@export var combat_fade_in_time := 2.0
@export var combat_fade_out_time := 1.0

var in_shard := false
var music_playing := true

# TODO: respond to user-given music volume in settings
@onready var mus_volume: float = %Music.volume_linear
@onready var combat_mus_volume: float = %CombatMusic.volume_linear

# Entry point for playing music
func start_jukebox() -> void:
	Dwelt.claim_requested.connect(func() -> void:
		fade_music_out()
		fade_combat_music_in()
		%CombatMusic.seek(4.0))
	
	# Connect signals that would influence the jukebox i.e., playing or stopping combat music
	Dwelt.player_effect_manager.effect_cancelled.connect(func(id: String) -> void:
		if id == "claiming":
			%Tambourine.play()
			fade_combat_music_out()
			fade_music_in())
	
	Dwelt.player_effect_manager.effect_finished.connect(func(id: String) -> void:
		if id == "claiming":
			%Tambourine.play()
			fade_combat_music_out()
			fade_music_in())
	
	fade_music_in()
	%Music.play()

func fade_music_in() -> void:
	music_playing = true
	
	%Music.volume_linear = 0.0
	var _t := create_tween()
	_t.tween_property(%Music, "volume_linear", mus_volume, fade_in_time)
	%Music.stream_paused = false

func fade_music_out() -> void:
	music_playing = false
	var _t := create_tween()
	_t.tween_property(%Music, "volume_linear", 0.0, fade_out_time)
	_t.tween_callback(func() -> void:
		# Restart music if it has been requested in the middle of fasing out
		if music_playing: fade_music_in()
		if !in_shard: %Music.stream_paused = true)

func fade_combat_music_in() -> void:
	%CombatMusic.volume_linear = 0.0
	var _t := create_tween()
	_t.tween_property(%CombatMusic, "volume_linear",
		combat_mus_volume, combat_fade_in_time)
	%CombatMusic.play()

func fade_combat_music_out() -> void:
	var _t := create_tween()
	_t.tween_property(%CombatMusic, "volume_linear",
		0.0, combat_fade_out_time)
	_t.tween_callback(%CombatMusic.stop)

func _ready() -> void:
	# Detect scene changes and start/stop regular music as needed
	get_tree().scene_changed.connect(func() -> void:
		if get_tree().current_scene is Shard:
			in_shard = true
			start_jukebox()
		elif get_tree().current_scene.name == "MainMenu":
			in_shard = false
			fade_music_out()
			fade_combat_music_out())
