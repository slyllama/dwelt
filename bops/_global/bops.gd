extends Node

enum Mode { INACTIVE, ACTIVE }

var mode := Mode.INACTIVE

signal mode_changed

func change_mode(_mode: Mode) -> void:
	mode = _mode
	mode_changed.emit()

# Activate building
func activate() -> void:
	if mode != Mode.INACTIVE: return # don't activate twice
	change_mode(Mode.ACTIVE)

# Deactivate building
func deactivate() -> void:
	if mode == Mode.INACTIVE: return # don't deactivate twice
	change_mode(Mode.INACTIVE)

func _ready() -> void:
	Utils.pdebug("Building server loaded.", "BOps")
