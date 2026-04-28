class_name GizmoMover extends Node3D
# Use collision layer/mask 5 for collision testing
# Collision layer/mask 6 for transverse testing

@export var pick_box: Area3D
@export var grabber: MeshInstance3D
@export var influence := 1.0

@onready var original_position := global_position

var offset_to_parent := Vector3.ZERO
var dragging := false
var drag_area: Area3D
var raycast: RayCast3D

func handle_mouse_raycast() -> Variant:
	if !Dwelt.camera: return
	var mouse_pos := get_viewport().get_mouse_position()
	var _from := Dwelt.camera.project_ray_origin(mouse_pos)
	var _to := _from + Dwelt.camera.project_ray_normal(mouse_pos) * 200.0
	var space_state := Dwelt.camera.get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(_from, _to)
	query.collide_with_areas = true
	query.collision_mask = 10000
	var intersection := space_state.intersect_ray(query)
	if intersection: return(intersection.position)
	else: return(null)

func generate_planes() -> void:
	# Drag area
	drag_area = Area3D.new()
	var drag_area_collision := CollisionShape3D.new()
	var drag_area_shape := BoxShape3D.new()
	drag_area_shape.size = Vector3(influence, influence, 0.01)
	drag_area_collision.shape = drag_area_shape
	drag_area.input_ray_pickable = false
	drag_area.add_child(drag_area_collision)
	drag_area.set_collision_layer_value(1, false)
	drag_area.set_collision_layer_value(5, true)
	add_child(drag_area)
	
	# Transverse drag area
	var transverse_drag_area := Area3D.new()
	var transverse_drag_area_collision := CollisionShape3D.new()
	var transverse_drag_area_shape := BoxShape3D.new()
	transverse_drag_area_shape.size = Vector3(0.01, influence, 0.1)
	transverse_drag_area_collision.shape = transverse_drag_area_shape
	transverse_drag_area.input_ray_pickable = false
	transverse_drag_area.add_child(transverse_drag_area_collision)
	transverse_drag_area.set_collision_layer_value(1, false)
	transverse_drag_area.set_collision_layer_value(6, true)
	drag_area.add_child(transverse_drag_area)
	
	# Transverse raycast
	raycast = RayCast3D.new()
	raycast.collide_with_areas = true
	raycast.target_position = Vector3(influence, 0.0, 0.0)
	raycast.set_collision_mask_value(1, false)
	raycast.set_collision_mask_value(6, true)
	drag_area.add_child(raycast)

func input_event() -> void:
	if Input.is_action_just_pressed("left_click"):
		generate_planes()
		BOps.drag_started.emit(self)
		dragging = true

func toggle_mouse_in_gizmo_grabber(state: bool) -> void:
	BOps.mouse_in_gizmo_grabber = state
	grabber.set_instance_shader_parameter("highlight", state)

func _ready() -> void:
	if !pick_box:
		Utils.pdebug("Gizmo missing pick box; freeing.",
		"GizmoMover")
		queue_free()
		return
	if !grabber:
		Utils.pdebug("Gizmo missing grabber; freeing.",
		"GizmoMover")
		queue_free()
		return
	
	BOps.drag_started.connect(func(gizmo: GizmoMover) -> void:
		if gizmo != self: queue_free())
	
	if "global_position" in get_parent():
		offset_to_parent = global_position - get_parent().global_position
	
	pick_box.input_event.connect(input_event.unbind(5))
	pick_box.mouse_entered.connect(toggle_mouse_in_gizmo_grabber.bind(true))
	pick_box.mouse_exited.connect(toggle_mouse_in_gizmo_grabber.bind(false))
	grabber.top_level = true

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("left_click"):
		if dragging:
			dragging = false
			BOps.mouse_in_gizmo_grabber = false
			queue_free()

var c := 5
var collision_delta := Vector3.ZERO

func _physics_process(_delta: float) -> void:
	if drag_area:
		drag_area.look_at(Dwelt.camera.global_position)
		drag_area.rotation *= Vector3(0, 1, 0)
	
	var _r: Variant = handle_mouse_raycast()
	if _r and raycast:
		raycast.global_position = (_r)
		raycast.position.x -= influence / 2.0
		if dragging:
			if c > 0:
				collision_delta = grabber.global_position - raycast.get_collision_point()
				c -= 1
				top_level = true
			else:
				if raycast.is_colliding():
					grabber.global_position = raycast.get_collision_point() + collision_delta
					get_parent().global_position = grabber.global_position - offset_to_parent
