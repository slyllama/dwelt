extends Node

const PATH := "user://settings.json"

const DEFAULT_SETTINGS := {
	"window_mode": "windowed"
}

@onready var settings := DEFAULT_SETTINGS.duplicate()
@onready var queued_changes := settings.duplicate()

signal applied(queued_changes: Dictionary)

func load_from_file() -> void:
	var _f = FileAccess.open(PATH, FileAccess.READ)
	var _loaded_settings = JSON.parse_string(_f.get_as_text())
	for _s in _loaded_settings:
		if _s in settings: # discard if no longer in the menu
			settings[_s] = _loaded_settings[_s]
	_f.close()

func save_to_file() -> void:
	var _f = FileAccess.open(PATH, FileAccess.WRITE)
	_f.store_line(JSON.stringify(settings, "\t"))
	_f.close()

func apply_queued_changes() -> void:
	for _s in queued_changes:
		if queued_changes[_s] == settings[_s]:
			# setting hasn't changed, so doesn't need to be reported
			queued_changes.erase(_s)
		else:
			# Write over the setting
			settings[_s] = queued_changes[_s]
	applied.emit(queued_changes)
	save_to_file()
	queued_changes = settings.duplicate() # reset

func _ready() -> void:
	if FileAccess.file_exists(PATH): load_from_file()
	else: save_to_file()
	
	applied.emit(settings)
