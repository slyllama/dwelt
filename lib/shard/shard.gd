extends Node3D

func _ready() -> void:
	# Saving and loading
	Global.quit_requested.connect(func():
		Save.save_value("player_position", $Player.position))
	var _player_position = Save.get_value("player_position")
	if _player_position:
		$Player.position = _player_position
