@tool
extends EditorPlugin

func make_save_default() -> void:
	if FileAccess.file_exists(Save.SAVE_PATH):
		DirAccess.copy_absolute(Save.SAVE_PATH, "res://default.json")

func _enter_tree() -> void:
	add_tool_menu_item("Make Save Default", make_save_default)

func _exit_tree() -> void:
	remove_tool_menu_item("Make Save Default")
