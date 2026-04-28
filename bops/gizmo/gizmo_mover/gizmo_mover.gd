class_name GizmoMover extends MeshInstance3D
# Use collision layer/mask 5 for collision testing
# Collision layer/mask 6 for transverse testing

@export var camera: Camera3D
@export var pick_box: Area3D
@export var influence := 10.0

var dragging := false
var drag_area: Area3D
var raycast: RayCast3D

func handle_mouse_raycast() -> Variant:
	if !camera: return
	var mouse_pos := get_viewport().get_mouse_position()
	var _from := camera.project_ray_origin(mouse_pos)
	var _to := _from + camera.project_ray_normal(mouse_pos) * 200.0
	var space_state := camera.get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(_from, _to)
	query.collide_with_areas = true
	query.collision_mask = 10000
	var intersection := space_state.intersect_ray(query)
	if intersection:
		return(intersection.position)
	else:
		return(null)

func generate_planes() -> void:
	# Drag area
	drag_area = Area3D.new()
	var drag_area_collision := CollisionShape3D.new()
	var drag_area_shape := BoxShape3D.new()
	drag_area_shape.size = Vector3(influence, 0.01, influence)
	drag_area_collision.shape = drag_area_shape
	drag_area.input_ray_pickable = false
	drag_area.add_child(drag_area_collision)
	drag_area.set_collision_layer_value(1, false)
	drag_area.set_collision_layer_value(5, true)
	add_child(drag_area)
	drag_area.top_level = true
	
	# Transverse drag area
	var transverse_drag_area := Area3D.new()
	var transverse_drag_area_collision := CollisionShape3D.new()
	var transverse_drag_area_shape := BoxShape3D.new()
	transverse_drag_area_shape.size = Vector3(0.01, 0.1, influence)
	transverse_drag_area_collision.shape = transverse_drag_area_shape
	transverse_drag_area.input_ray_pickable = false
	transverse_drag_area.add_child(transverse_drag_area_collision)
	transverse_drag_area.set_collision_layer_value(1, false)
	transverse_drag_area.set_collision_layer_value(6, true)
	add_child(transverse_drag_area)
	transverse_drag_area.top_level = true
	
	# Transverse raycast
	raycast = RayCast3D.new()
	raycast.collide_with_areas = true
	raycast.target_position = Vector3(influence, 0.0, 0.0)
	raycast.set_collision_mask_value(1, false)
	raycast.set_collision_mask_value(6, true)
	add_child(raycast)
	raycast.top_level = true

func input_event() -> void:
	if Input.is_action_just_pressed("left_click"):
		if handle_mouse_raycast():
			if raycast.is_colliding():
				print(handle_mouse_raycast() - raycast.get_collision_point())
		dragging = true

func _ready() -> void:
	if !pick_box:
		Utils.pdebug("Gizmo missing pick box; freeing.",
		"GizmoMover")
		queue_free()
		return
	pick_box.input_event.connect(input_event.unbind(5))
	# TODO: doing now for testing
	generate_planes()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("left_click"):
		if dragging:
			dragging = false
			queue_free()

func _physics_process(_delta: float) -> void:
	raycast.position.x = -influence / 2.0
	var _r: Variant = handle_mouse_raycast()
	if dragging and _r:
		raycast.global_position = (_r)
		raycast.position.x -= influence / 2.0
		if raycast.is_colliding():
			global_position = raycast.get_collision_point()
