extends Node3D

#func _init() -> void:
	#AudioServer.set_bus_volume_db(0, linear_to_db(0.0))

func _ready() -> void:
	# Saving and loading
	Global.quit_requested.connect(func():
		Save.save_value("player_position", $Player.position))
	var _player_position = Save.get_value("player_position")
	if _player_position:
		$Player.position = _player_position
