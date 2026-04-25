extends Node3D

@onready var target_position := global_position

@export var active := false:
	set(_active):
		active = _active
		visible = active

@export var follow_mouse := false

var mesh: Node3D

func update_mesh(new_mesh: Node3D) -> void:
	if mesh:
		mesh.queue_free() # if there is an existing mesh, free it
	if new_mesh:
		mesh = new_mesh.duplicate()
		var _g := MakeGhostMesh.new()
		add_child(mesh)
		mesh.add_child(_g)

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
		if intersection.position.distance_to(Dwelt.player.global_position) <= 5.0:
			target_position = intersection.position

func _ready() -> void:
	# TODO: checking replacing the ghost with various things
	Dwelt.selected_gadget_changed.connect(func(gadget: Gadget) -> void:
		if gadget: update_mesh(gadget.model)
		else: update_mesh(null))
	
	visible = active

func _physics_process(_delta: float) -> void:
	if !follow_mouse or !active: return
	if !Dwelt.panning:
		handle_mouse_raycast()
	global_position = target_position
