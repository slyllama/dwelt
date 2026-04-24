@icon("res://generic/icons/UIPane.svg")
@tool
class_name UIPane extends PanelContainer
# UI pane - generic window class

const FADE_SPEED = 0.08 # time to fade in and out during opening and closing

@export var title := "((UIPane))":
	get: return(title)
	set(_title):
		title = _title
		%Title.text = title
@export var ui_id := "ui_pane"
@export var closeable := true:
	get: return(closeable)
	set(_closeable):
		closeable = _closeable
		%Close.visible = closeable

const PADDING := 100.0 # used to calculate pane position limits
var cursor_last_in_window := true
var dragging := false
# Difference between where the drag was initiated and the pane's
# actual position
var offset := Vector2.ZERO

signal clicked

# WARNING: never call this directly - always use `close_pane()` on the
# UIPaneManager to properly deregister a pane
func close() -> void:
	# Fade out before freeing
	var _fade_tween := create_tween()
	_fade_tween.tween_property(self, "modulate:a", 0.0, FADE_SPEED)
	_fade_tween.tween_callback(queue_free)

func move_to_center() -> void:
	if Engine.is_editor_hint(): return
	set_anchors_preset(PRESET_CENTER)
	position = Utils.get_window_center() - size / 2.0

func _init() -> void:
	if !Engine.is_editor_hint():
		modulate.a = 0.0

func _ready() -> void:
	%Close.visible = closeable
	if Engine.is_editor_hint(): return
	
	# Play "click" effects on every button
	for _n: Node in Utils.get_all_children(self):
		if _n is BaseButton:
			_n.pressed.connect(func() -> void:
				if !_n == %Close:
					clicked.emit()
				Dwelt.click_sound_requested.emit())
	
	# Fade in and play open sound
	var _fade_tween := create_tween()
	_fade_tween.tween_property(self, "modulate:a", 1.0, FADE_SPEED)
	$Open.play()

func _process(_delta: float) -> void:
	$BorderEffect.global_position = global_position + size - Vector2(80.0, 122.0)

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

func _on_close_pressed() -> void:
	Dwelt.ui_pane_manager.close_pane(self)
