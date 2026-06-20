extends Node

const GRAVITY := -9.8

# References
var camera: Camera3D
var player: DweltPlayer
var ui_pane_manager: UIPaneManager

var current_shard_id := ""
var first_run := true
var panning := false
var pan_cooldown := false
var shard_path_to_load := "" # this shard will be loaded next time ShardLoader is entered

# Global signal bus
signal camera_pan_started
signal camera_pan_ended

# Signals which fire events rather than intercept them
signal emit_click_sound
signal play_flash(position: Vector2)
signal shake_camera

func discord_update_details(text: String) -> void:
	DiscordRPC.details = text
	if DiscordRPC.get_is_discord_working():
		DiscordRPC.refresh()

func _ready() -> void:
	emit_click_sound.connect($Click.play)
	
	# Connect settings
	Settings.setting_applied.connect(func(setting: String, value: String) -> void:
		if setting == "volume":
			var _clamped_vol: float = clamp(float(value), 0.0, 1.0)
			AudioServer.set_bus_volume_linear(0, float(_clamped_vol)))
	
	Utils.debug_sent.connect(func(string: String) -> void:
		if string == "/pause": get_tree().paused = true
		elif string == "/unpause": get_tree().paused = false)
