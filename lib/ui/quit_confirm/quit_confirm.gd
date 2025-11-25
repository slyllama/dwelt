@tool
extends UIPane

func _on_exit_pressed() -> void:
	Global.request_quit()

func _on_continue_pressed() -> void:
	close()
