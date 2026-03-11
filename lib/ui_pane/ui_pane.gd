class_name UIPane extends Panel
# UI pane - generic window class

const PADDING := 30.0 # pane can't be carried outside of this padding around the window
var cursor_last_in_window := true

func _on_header_gui_input(event: InputEvent) -> void:
	# Handle window dragging, including stopping dragging if the cursor gets
	# too close to the game window, and recovering once it re-enters
	if Input.is_action_pressed("left_click"):
		if (!cursor_last_in_window
			and Utils.cursor_in_window(PADDING)):
			position = get_window().get_mouse_position()
		if (event is InputEventMouseMotion
			and Utils.cursor_in_window(PADDING)):
			position += event.relative
		cursor_last_in_window = Utils.cursor_in_window(PADDING)
