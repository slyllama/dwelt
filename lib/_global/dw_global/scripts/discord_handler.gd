extends Node

const TICK := 0.5 # Discord callbacks run on this tick

func _ready() -> void:
	DiscordRPC.app_id = 1494972527858946110
	DiscordRPC.start_timestamp = int(Time.get_unix_time_from_system())
	if DiscordRPC.get_is_discord_working():
		DiscordRPC.refresh()

var c := 0.0

func _process(delta: float) -> void:
	c += delta
	if c > TICK:
		DiscordRPC.run_callbacks()
		c = 0
