class_name Gizmo extends Node3D
# Base class for identifying and extending other gizmos

@export var pick_box: Area3D

var dragging := false

func clear() -> void:
	dragging = false
	BOps.mouse_in_gizmo_grabber = false
	queue_free()

func input_event() -> void:
	if Input.is_action_just_pressed("left_click"):
		top_level = true
		BOps.gizmo_drag_started.emit(self)
		dragging = true

func toggle_mouse_in_gizmo_grabber(state: bool) -> void:
	BOps.mouse_in_gizmo_grabber = state

func _ready() -> void:
	if !pick_box:
		Utils.pdebug("Gizmo missing pick box; freeing.", "GizmoMover")
		clear()
		return
	
	pick_box.input_event.connect(input_event.unbind(5))
	pick_box.mouse_entered.connect(toggle_mouse_in_gizmo_grabber.bind(true))
	pick_box.mouse_exited.connect(toggle_mouse_in_gizmo_grabber.bind(false))
	
	# Clear this gizmo if a a different one was selected
	BOps.gizmo_drag_started.connect(func(gizmo: Gizmo) -> void:
		if gizmo != self: clear())
