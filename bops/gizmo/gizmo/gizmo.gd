class_name Gizmo extends MeshInstance3D
# Base class for identifying and extending other gizmos

@export var pick_box: Area3D

var dragging := false

func clear() -> void:
	dragging = false
	BOps.mouse_in_gizmo_grabber = false
	queue_free()

func _ready() -> void:
	if !pick_box:
		Utils.pdebug("Gizmo missing pick box; freeing.", "GizmoMover")
		clear()
		return
	
	# Clear this gizmo if a a different one was selected
	BOps.gizmo_drag_started.connect(func(gizmo: Gizmo) -> void:
		if gizmo != self: clear())
