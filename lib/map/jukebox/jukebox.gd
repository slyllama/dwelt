extends AudioStreamPlayer
# Jukebox
# The jukebox makes sure that music is always playing appropriately

@export var track_list: Array[AudioStreamOggVorbis]
@export var enabled := true

var rng = RandomNumberGenerator.new()
var tracks: Array[AudioStreamOggVorbis] = []
var tracks_alt: Array[AudioStreamOggVorbis] = []
var using_alt = false

# Will randomly select tracks from `tracks` and swap them over to `tracks_alt`
# until they have all been used up, and then do the same from `tracks_alt`;
# `using_alt` is used to keep track of this
func load_track() -> void:
	if !using_alt:
		var selected_id = rng.randi_range(0, tracks.size() - 1)
		set_stream(tracks[selected_id])
		play()
		tracks_alt.append(tracks[selected_id])
		tracks.remove_at(selected_id)
		if tracks == []: using_alt = true
		return
	else:
		var selected_id = rng.randi_range(0, tracks_alt.size() - 1)
		set_stream(tracks_alt[selected_id])
		play()
		tracks.append(tracks_alt[selected_id])
		tracks_alt.remove_at(selected_id)
		if tracks_alt == []: using_alt = false
		return

func _ready() -> void:
	# Connect button click and hover effects, called through Global
	Global.hover_sound.connect(func(): $Hover.play())
	Global.click_sound.connect(func(): $Click.play())
	
	# `enabled` only disables music, not sound effects
	if !enabled: return
	if track_list == []: return
	tracks = track_list.duplicate()
	await get_tree().create_timer(2.0).timeout
	load_track()

func _on_finished() -> void:
	# Start a delay timer to provide a break in-between songs
	$Timer.start()

func _on_timer_timeout() -> void:
	# Load the next track once the delay timer has completed
	load_track()
