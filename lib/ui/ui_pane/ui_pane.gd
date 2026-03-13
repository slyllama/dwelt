@tool
class_name UIPane extends PanelContainer
# UI pane - generic window class

@export var title := "((UIPane))":
	get: return(title)
	set(_title):
		title = _title
		%Title.text = title

const PADDING := 100.0 # used to calculate pane position limits
var cursor_last_in_window := true
var dragging := false
# Difference between where the drag was initiated and the pane's
# actual position
var offset := Vector2.ZERO

signal clicked

func _on_header_gui_input(_event: InputEvent) -> void:
	if Engine.is_editor_hint(): return
	
	# Handle pane dragging, including clamping its position when the cursor
	# leaves the window
	if Input.is_action_pressed("left_click"):
		# Only drag the pane if the operation was started within the
		# pane's header
		if !dragging: return
		# Get scaled window size
		var _w: Vector2 = get_window().size / get_window().content_scale_factor
		
		position = get_window().get_mouse_position() + offset
		position.x = clamp(position.x, -PADDING, _w.x - PADDING)
		position.y = clamp(position.y, 0.0, _w.y - PADDING)

func _on_gui_input(_event: InputEvent) -> void:
	if Engine.is_editor_hint(): return
	
	# Handle dragging initiation and ending
	if Input.is_action_just_pressed("left_click"):
		offset = position - get_window().get_mouse_position()
		dragging = true
		clicked.emit()
	elif Input.is_action_just_released("left_click"):
		dragging = false
