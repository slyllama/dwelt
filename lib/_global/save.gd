extends Node
# Save handling - quitting the game is handled here, too.

const SAVE_PATH := "user://save.dat"
const NEW_SAVE := {
	"player_position": Vector3.ZERO,
	"camera_rotation": Vector3(deg_to_rad(-15.0), 0.0, 0.0) }

var write_queue: Array[Dictionary] = []

func _handle_quit() -> void:
	await get_tree().process_frame
	for _i in write_queue.size():
		await get_tree().process_frame
	get_tree().quit()

func file_exists() -> bool:
	return(FileAccess.file_exists(SAVE_PATH))

func create() -> void:
	var _f := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	_f.store_var(NEW_SAVE)
	_f.close()

func get_value(param: String) -> Variant:
	var _f := FileAccess.open(SAVE_PATH, FileAccess.READ)
	var _d: Dictionary = _f.get_var()
	_f.close()
	if param in _d:
		return(_d[param])
	else: return(null)

func save_value(param: String, value: Variant) -> void:
	write_queue.append({param: value})

func _ready() -> void:
	Global.quit_requested.connect(_handle_quit)
	get_tree().set_auto_accept_quit(false) # prevent automatic quitting
	if !file_exists():
		Utils.pdebug("No save file exists, creating one.", "Save")
		create()

func _process(_delta: float) -> void:
	if write_queue.size() < 1: return
	for _entry in write_queue:
		var _f := FileAccess.open(SAVE_PATH, FileAccess.READ)
		var _d: Dictionary = _f.get_var()
		_d[_entry.keys()[0]] = _entry.values()[0]
		_f.close()
		
		var _g := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
		_g.store_var(_d)
		_g.close()
		write_queue.erase(_entry)

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		Global.quit_requested.emit()
