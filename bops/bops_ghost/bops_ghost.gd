extends Node3D

@onready var target_position := global_position

func handle_mouse_raycast() -> void:
	var camera := Dwelt.camera
	var mouse_pos := get_viewport().get_mouse_position()
	var _from := camera.project_ray_origin(mouse_pos)
	var _to := _from + camera.project_ray_normal(mouse_pos) * 200.0
	var space_state := camera.get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(_from, _to)
	
	query.collision_mask = 001
	query.exclude = [Dwelt.player]
	
	var intersection := space_state.intersect_ray(query)
	if intersection:
		target_position = intersection.position

func _physics_process(_delta: float) -> void:
	if !Dwelt.panning:
		handle_mouse_raycast()
	global_position = lerp(global_position, target_position, Utils.crit_plerp(30.0))
