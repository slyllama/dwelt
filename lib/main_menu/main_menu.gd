extends CanvasLayer

const SETTINGS_PANE_PATH := "res://lib/settings/settings_pane/settings_pane.tscn"

signal disable_finished

func _disable_and_prepare_exit() -> void: # use when changing scene or quitting
	$Bell.play()
	
	for _b: Node in $Box.get_children():
		if _b is Button: _b.disabled = true
	%FG.visible = true
	
	var _t := create_tween()
	_t.tween_property($Music, "volume_linear", 0.0, 0.2)
	_t.tween_callback(disable_finished.emit)

func _ready() -> void:
	# Click sounds
	for _b: Node in $Box.get_children():
		if _b is Button:
			_b.pressed.connect(func() -> void:
				DwGlobal.emit_click_sound.emit())
	
	DwGlobal.discord_update_details("In Main Menu")
	for _i in 3: await get_tree().process_frame
	if DwGlobal.first_run:
		DwSettings.apply_all_settings(false)
	else: # don't re-apply window size in case the player has resized it manually
		DwSettings.apply_all_settings(false, ["full_screen"])

func _input(_event: InputEvent) -> void:
	if %FG.visible: return # transition has started
	if (Input.is_action_just_pressed("ui_cancel")
		and %UIPaneManager.panes.size() == 0):
		_on_settings_pressed()

func _on_play_pressed() -> void:
	_disable_and_prepare_exit()
	var _t := create_tween()
	_t.tween_property(%FG, "modulate:a", 1.0, 0.2)
	await _t.finished
	get_tree().change_scene_to_file(
		"res://lib/shard/shard_loader/shard_loader.tscn")

func _on_quit_pressed() -> void:
	_disable_and_prepare_exit()
	await disable_finished
	get_tree().quit()

func _on_settings_pressed() -> void:
	%UIPaneManager.toggle_open(SETTINGS_PANE_PATH, "settings_pane")
