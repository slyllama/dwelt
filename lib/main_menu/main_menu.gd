extends Node3D

const SHARD_LOADER_PATH := "res://lib/shard/shard_loader/shard_loader.tscn"
const SettingsPane = preload("res://lib/settings/settings_pane/settings_pane.tscn")

var shard_load_started := false

func fade_music() -> void:
	var _t := create_tween()
	_t.tween_property($Music, "volume_linear", 0.0, 0.25)

func go_to_shard(path: String) -> void:
	if shard_load_started: return
	%Curtain.trans_in()
	fade_music()
	#%MenuScene.target_z_position = -0.75
	
	shard_load_started = true
	Dwelt.shard_path_to_load = path
	await %Curtain.trans_finished
	get_tree().change_scene_to_file(SHARD_LOADER_PATH)

func _ready() -> void:
	await get_tree().process_frame
	
	if Dwelt.first_run: Settings.apply_all_settings(false)
	else: Settings.apply_all_settings(false, ["full_screen"])
	
	# Handle visibility and focusing depending on whether a save exists or not
	if Save.save_exists():
		%Continue.visible = true
		%Continue.grab_focus()
	else: %NewGame.grab_focus()
	
	%Curtain.visible = true
	DiscordRPC.details = "In Menu"
	DiscordRPC.refresh()
	
	await get_tree().create_timer(0.1).timeout
	%Curtain.trans_out()
	$Music.play()

func _on_play_pressed() -> void:
	go_to_shard("res://shards/acidfields/acidfields.tscn")

func _on_play_debug_pressed() -> void:
	go_to_shard("res://shards/debug/debug.tscn")

func _on_settings_pressed() -> void:
	var _pane_open := false
	for _n: UIPane in %UIPaneManager.get_children():
		if _n.ui_id == "settings_pane":
			_pane_open = true
			%UIPaneManager.close_pane(_n)
	if !_pane_open and !shard_load_started:
		var settings_pane: UIPane = SettingsPane.instantiate()
		%UIPaneManager.add_child(settings_pane)
		settings_pane.set_anchors_preset(Control.PRESET_CENTER)
		settings_pane.move_to_center()
		# Don't return to the menu while in the menu
		settings_pane.get_node("Box/Menu").visible = false

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_new_game_pressed() -> void:
	Save.new_file_from_default() # force a new game
	go_to_shard("res://shards/acidfields/acidfields.tscn")
