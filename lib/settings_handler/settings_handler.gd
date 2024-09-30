extends Node

var settings = {
	"fov": 5
}

signal setting_changed(parameter)

func refresh() -> void:
	for s in settings:
		setting_changed.emit(s)

func update(parameter, value) -> void:
	settings[parameter] = value
	setting_changed.emit(parameter)
