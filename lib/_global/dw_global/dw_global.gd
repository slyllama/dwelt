extends Node

const GRAVITY := -9.8
const NO_SHADOW_EXPRESSION := "_ns"
const SAVE_PATH := "user://save/"

enum ToolMode { NORMAL, SELECT_CLEANSE }

# References
var camera: Camera3D
var player: DweltPlayer
var ui_pane_manager: UIPaneManager

var current_shard: Shard
var current_shard_id := ""
var first_run := true
var music_volume := 0.0
var panning := false
var pan_cooldown := false
var tool_mode: ToolMode = ToolMode.NORMAL

# Global signal bus
signal camera_pan_started
signal camera_pan_ended
signal tool_mode_changed(new_tool_mode: ToolMode)
signal skill_used(id: String)

# Signals which fire events rather than intercept them
signal emit_click_sound
signal shake_camera

#region Discord functions

func discord_update_state(text := "") -> void:
	DiscordRPC.state = text
	if DiscordRPC.get_is_discord_working():
		DiscordRPC.refresh()

func discord_update_details(text := "") -> void:
	DiscordRPC.details = text
	if DiscordRPC.get_is_discord_working():
		DiscordRPC.refresh()

#endregion

# Reset shard-specific variables on leaving a shard
# (i.e., returning to the main menu)
func reset_shard_session() -> void:
	DwUtils.pdebug("Resetting shard session.", "DwGlobal")
	current_shard = null
	current_shard_id = ""
	tool_mode = ToolMode.NORMAL

func change_tool_mode(new_tool_mode: ToolMode) -> void:
	tool_mode = new_tool_mode
	tool_mode_changed.emit(new_tool_mode)

func _init() -> void:
	# Ensure the save directory exists if it doesn't already
	if !DirAccess.dir_exists_absolute(SAVE_PATH):
		DirAccess.make_dir_recursive_absolute(SAVE_PATH)

func _ready() -> void:
	emit_click_sound.connect($Click.play)
	
	# Connect settings
	DwSettings.setting_applied.connect(func(setting: String, value: String) -> void:
		if setting == "volume":
			var _clamped_vol: float = clamp(float(value), 0.0, 1.0)
			AudioServer.set_bus_volume_linear(0, float(_clamped_vol)))
	
	DwUtils.debug_sent.connect(func(string: String) -> void:
		if string == "/pause": get_tree().paused = true
		elif string == "/unpause": get_tree().paused = false)
