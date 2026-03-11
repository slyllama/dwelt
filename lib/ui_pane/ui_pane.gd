@tool
class_name UIPane extends PanelContainer
# UI pane - generic window class

@export var title := "((UIPane))":
	get: return(title)
	set(_title):
		title = _title
		%Title.text = title

const PADDING := 30.0 # pane can't be carried outside of this padding around the window
var cursor_last_in_window := true
var dragging := false

signal clicked

func _on_header_gui_input(event: InputEvent) -> void:
	if Engine.is_editor_hint(): return
	
	# Handle window dragging, including stopping dragging if the cursor gets
	# too close to the game window, and recovering once it re-enters
	if Input.is_action_pressed("left_click"):
		# only drag the pane if the operation was started within the pane's
		# header
		if !dragging: return
		if (!cursor_last_in_window
			and Utils.cursor_in_window(PADDING)):
			position = get_window().get_mouse_position()
		if (event is InputEventMouseMotion
			and Utils.cursor_in_window(PADDING)):
			position += event.relative
		cursor_last_in_window = Utils.cursor_in_window(PADDING)

func _on_gui_input(_event: InputEvent) -> void:
	if Engine.is_editor_hint(): return
	
	# Handle dragging initiation and ending
	if Input.is_action_just_pressed("left_click"):
		dragging = true
		Utils.pdebug("Clicked pane " + str(name))
		clicked.emit()
	elif Input.is_action_just_released("left_click"):
		dragging = false
