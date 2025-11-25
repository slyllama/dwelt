@tool
extends UIPane

func _on_apply_pressed() -> void:
	SettingsHandler.apply_queued_changes()
	close()
