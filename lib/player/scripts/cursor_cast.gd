extends Node
# cursor_cast
# Handles raycasting from the camera through the mouse cursor

@onready var camera: Camera3D = get_parent()

var current_collider: CollisionObject3D
var last_click_in_ui := false
var last_hovered_gadget: Gadget

# Always wait a short cooldown before processing an input action again
const COOLDOWN := 0.1
var _cooldown := 0.0

func handle_mouse_raycast() -> void:
	var mouse_pos := get_viewport().get_mouse_position()
	var _from := camera.project_ray_origin(mouse_pos)
	var _to := _from + camera.project_ray_normal(mouse_pos) * 200.0
	var space_state := camera.get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(_from, _to)
	
	query.collide_with_areas = true
	query.collision_mask = 100
	
	var intersection := space_state.intersect_ray(query)
	if intersection:
		current_collider = intersection.collider
	else: current_collider = null

func handle_mouse_release() -> void:
	if !last_click_in_ui and !get_window().gui_get_hovered_control():
		if _cooldown > 0.01: return # reject if too close to the last successful input
		_cooldown = COOLDOWN
		# TODO: MOUSE CLICK STUFF HERE

func handle_gadget_hover() -> void:
	if current_collider != last_hovered_gadget:
		DwGadget.gadget_hovered.emit(current_collider)
	last_hovered_gadget = current_collider

# Only perform when a valid input event is happening
func _input(_event: InputEvent) -> void:
	if !Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		# Cancel any hovered gadgets when panning events start
		DwGadget.gadget_hovered.emit(null)
		return # don't check during panning events
	if Input.is_action_just_pressed("left_click"):
		last_click_in_ui = false
		if get_window().gui_get_hovered_control():
			last_click_in_ui = true
	if Input.is_action_just_released("left_click"):
		# Didn't start *or* end in UI
		handle_mouse_release()

func _process(delta: float) -> void:
	handle_mouse_raycast()
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		handle_gadget_hover()
	if _cooldown > 0.0:
		_cooldown -= delta
