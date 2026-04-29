class_name GizmoMover extends Gizmo
# Use collision layer/mask 5 for collision testing
# Collision layer/mask 6 for transverse testing

@export var grabber: MeshInstance3D
@export var influence := 100.0
@export var single_axis := true

@onready var original_position := global_position

var offset_to_parent := Vector3.ZERO
var drag_area: Area3D
var raycast: RayCast3D

func get_mouse_raycast() -> Variant:
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
	
	if single_axis:
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
	super()
	if Input.is_action_just_pressed("left_click"):
		generate_planes()

func toggle_mouse_in_gizmo_grabber(state: bool) -> void:
	super(state)
	grabber.set_instance_shader_parameter("highlight", state)

func _ready() -> void:
	super()
	
	# Error out on missing pick boxes, grabbers, etc
	if !grabber:
		Utils.pdebug("Gizmo missing grabber; freeing.", "GizmoMover")
		clear()
		return
	
	if "global_position" in get_parent():
		offset_to_parent = global_position - get_parent().global_position
	
	grabber.top_level = true

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("left_click"):
		if dragging:
			BOps.gizmo_drag_ended.emit()
			clear()

var c := 3
var collision_delta := Vector3.ZERO

func _physics_process(_delta: float) -> void:
	if drag_area:
		if single_axis:
			drag_area.look_at(Dwelt.camera.global_position)
			drag_area.rotation *= Vector3(0, 1, 0)
	
	var _mouse_raycast: Variant = get_mouse_raycast()
	if !_mouse_raycast: return
	if single_axis:
		if raycast:
			raycast.global_position = (_mouse_raycast)
			raycast.position.x -= influence / 2.0
			if dragging:
				if c > 0:
					collision_delta = grabber.global_position - raycast.get_collision_point()
					c -= 1
				else:
					if raycast.is_colliding():
						grabber.global_position = raycast.get_collision_point() + collision_delta
						get_parent().global_position = grabber.global_position - offset_to_parent
	else: # not single-axis; uses the cursor raycast directly onto the drag plane
		if dragging:
			if c > 0:
				collision_delta = grabber.global_position - _mouse_raycast
				c -= 1
			else:
				grabber.global_position = _mouse_raycast + collision_delta
				get_parent().global_position = grabber.global_position - offset_to_parent
