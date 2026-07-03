extends CanvasLayer

const SETTINGS_PANE_PATH := "res://lib/settings/settings_pane/settings_pane.tscn"

func _ready() -> void:
	# Click sounds
	for _b: Button in $Box.get_children():
		_b.pressed.connect(func() -> void:
			DwGlobal.emit_click_sound.emit())
	
	DwGlobal.discord_update_details("In Main Menu")
	for _i in 3: await get_tree().process_frame
	DwSettings.apply_all_settings(false)
	
	$Music.play()

func _input(_event: InputEvent) -> void:
	if %FG.visible: return # transition has started
	if (Input.is_action_just_pressed("ui_cancel")
		and %UIPaneManager.panes.size() == 0):
		_on_settings_pressed()

func _on_play_pressed() -> void:
	for _b: Button in $Box.get_children():
		_b.disabled = true
	
	%FG.visible = true
	var _t := create_tween()
	_t.tween_property(%FG, "modulate:a", 1.0, 0.2)
	await _t.finished
	
	get_tree().change_scene_to_file(
		"res://lib/shard/shard_loader/shard_loader.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_settings_pressed() -> void:
	%UIPaneManager.toggle_open(SETTINGS_PANE_PATH, "settings_pane")
