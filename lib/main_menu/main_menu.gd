extends CanvasLayer

func _ready() -> void:
	DwSettings.apply_all_settings(false)
	DwGlobal.discord_update_details("In Main Menu")

func _on_play_pressed() -> void:
	for _b: Button in $Box.get_children():
		_b.disabled = true
	
	$FG.visible = true
	var _t := create_tween()
	_t.tween_property($FG, "modulate:a", 1.0, 0.2)
	await _t.finished
	
	get_tree().change_scene_to_file(
		"res://lib/shard/shard_loader/shard_loader.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
