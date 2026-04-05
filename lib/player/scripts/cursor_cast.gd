extends Node
# cursor_cast
# Handles raycasting from the camera through the mouse cursor

@onready var camera: Camera3D = get_parent()

var current_collider: CollisionObject3D
var last_click_in_ui := false

func handle_mouse_raycast() -> void:
	var mouse_pos := get_viewport().get_mouse_position()
	var _from := camera.project_ray_origin(mouse_pos)
	var _to := _from + camera.project_ray_normal(mouse_pos) * 200.0
	var space_state := camera.get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(_from, _to)
	
	query.collide_with_areas = true
	
	var intersection := space_state.intersect_ray(query)
	if intersection:
		current_collider = intersection.collider
	else: current_collider = null

# Only perform when a valid input event is happening
func _input(event: InputEvent) -> void:
	if !Input.mouse_mode == Input.MOUSE_MODE_VISIBLE: return # don't check during panning events
	if event is InputEventMouseMotion:
		handle_mouse_raycast()
	
	if Input.is_action_just_pressed("left_click"):
		last_click_in_ui = false
		if get_window().gui_get_hovered_control():
			last_click_in_ui = true
	if Input.is_action_just_released("left_click"):
		if !last_click_in_ui:
			if current_collider is Gadget:
				Dwelt.update_selected_gadget(current_collider)
			else:
				Dwelt.update_selected_gadget(null)
			Dwelt.clicked_collision_object.emit(current_collider)
