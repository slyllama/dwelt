@tool
extends UIPane

func _on_apply_pressed() -> void:
	for _n in $Box.get_children():
		if _n is Option:
			print(_n.id + ": " + _n.current_option.id)
	SettingsHandler.apply_queued_changes()
	close()
