extends UIPane

func _on_exit_pressed() -> void:
	Global.quit_requested.emit()

func _on_continue_pressed() -> void:
	close()
