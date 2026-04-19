extends Node

func _ready() -> void:
	DiscordRPC.app_id = 1494972527858946110
	DiscordRPC.start_timestamp = int(Time.get_unix_time_from_system())
	DiscordRPC.state = "In Shard"
	DiscordRPC.details = "((???))"
	if DiscordRPC.get_is_discord_working():
		DiscordRPC.refresh()
