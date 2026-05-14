extends Node3D

const SHARD_LOADER_PATH := "res://lib/shard/shard_loader/shard_loader.tscn"
const SettingsPane = preload("res://lib/settings/settings_pane/settings_pane.tscn")

var shard_load_started := false

func fade_music() -> void:
	var _t := create_tween()
	_t.tween_property($Music, "volume_linear", 0.0, 0.25)

# Update focus cursor position
func update_cursor_position(cursor_position: Vector2) -> void:
	%FocusCursor.target_position = cursor_position

func snap_cursor_to_focus() -> void:
	if get_window().gui_get_focus_owner():
		var _focus: Control = get_window().gui_get_focus_owner()
		var _new_focus_position := _focus.global_position + _focus.size / 2.0
		update_cursor_position(_new_focus_position)
		%FocusCursor.global_position = _new_focus_position

func go_to_shard(path: String) -> void:
	if shard_load_started: return
	%Curtain.trans_in()
	fade_music()
	
	shard_load_started = true
	Dwelt.shard_path_to_load = path
	await %Curtain.trans_finished
	get_tree().change_scene_to_file(SHARD_LOADER_PATH)

func _ready() -> void:
	Dwelt.ui_pane_manager = %UIPaneManager
	
	get_window().gui_focus_changed.connect(func(node: Control) -> void:
		if node in $FG/Box.get_children():
			update_cursor_position(node.global_position + node.size / 2.0))
	await get_tree().process_frame
	
	if Dwelt.first_run: Settings.apply_all_settings(false)
	else: Settings.apply_all_settings(false, ["full_screen"])
	
	# Handle visibility and focusing depending on whether a save exists or not
	# Make sure menu buttons "wrap around"
	if Save.save_exists():
		%Continue.focus_neighbor_top = %Continue.get_path_to(%Quit)
		%Quit.focus_neighbor_bottom = %Quit.get_path_to(%Continue)
		%Continue.visible = true
		%Continue.grab_focus()
	else:
		%NewGame.focus_neighbor_top = %NewGame.get_path_to(%Quit)
		%Quit.focus_neighbor_bottom = %Quit.get_path_to(%NewGame)
		%NewGame.grab_focus()
	
	%Curtain.visible = true
	DiscordRPC.details = "In Menu"
	DiscordRPC.refresh()
	
	# Almost immediately set and update focus cursor position
	await get_tree().create_timer(0.1).timeout
	snap_cursor_to_focus()
	
	%Curtain.trans_out()
	await get_tree().create_timer(0.65).timeout
	if get_window().gui_get_focus_owner():
		%CursorAnim.play("fade")
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
		
		# If closing the settings pane, return the focus to the "settings" button
		settings_pane.set_anchors_preset(Control.PRESET_CENTER)
		settings_pane.move_to_center()
		settings_pane.tree_exiting.connect(func() -> void:
			%Settings.grab_focus()
			snap_cursor_to_focus())
		
		# Don't return to the menu while in the menu
		settings_pane.get_node("Box/Menu").visible = false

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_new_game_pressed() -> void:
	Save.new_file_from_default() # force a new game
	go_to_shard("res://shards/acidfields/acidfields.tscn")

func _on_ui_pane_manager_panes_updated(pane_count: int) -> void:
	if pane_count > 0: %CursorAnim.play_backwards("fade")
	else: %CursorAnim.play("fade")
