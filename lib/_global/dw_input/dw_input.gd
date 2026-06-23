extends Node
# Handle input actions specific to Dwelt

var in_text_edit_mode := false
var last_focused_control: Control

# Incur a delay before "text edit mode" is released - prevents the player
# from being jogged if the player hits an movement key and then immediately
# accepts the input
func handle_changed_focus_owner(new_owner: Control) -> void:
	if new_owner is LineEdit:
		in_text_edit_mode = true
	else:
		if last_focused_control is LineEdit:
			await get_tree().create_timer(0.1).timeout
			if !get_window().gui_get_focus_owner() is LineEdit:
				in_text_edit_mode = false

# Handle callbacks when the focus owner changes, while also recording the
# previous focus owner
func _process(_delta: float) -> void:
	var _focus_owner := get_window().gui_get_focus_owner()
	if _focus_owner != last_focused_control:
		handle_changed_focus_owner(_focus_owner)
		last_focused_control = _focus_owner
