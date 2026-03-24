extends Node
# cursor_cast
# Handles raycasting from the camera through the mouse cursor

@onready var camera: Camera3D = get_parent()

func handle_mouse_raycast() -> void:
	var mouse_pos := get_viewport().get_mouse_position()
	var _from := camera.project_ray_origin(mouse_pos)
	var _to := _from + camera.project_ray_normal(mouse_pos) * 200.0
	var space_state := camera.get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(_from, _to)
	
	query.collide_with_areas = true
	
	var intersection := space_state.intersect_ray(query)
	if intersection:
		pass # TODO: cursor intersection

# Only perform when a valid input event is happening
func _input(event: InputEvent) -> void:
	if (event is InputEventMouseMotion
		and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE):
		handle_mouse_raycast()
