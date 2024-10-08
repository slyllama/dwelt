class_name Minimap extends Panel
const FADE_TIME = 0.3

var magnitude: float
var zoom: float
var image_offset: Vector2
var image_scale: Vector2
var object_scale: float

var objects = []

func update() -> void:
	var data = Global.minimap_data
	if "image_path" in data:
		if ResourceLoader.exists(data["image_path"]):
			$Root/MapImage.texture = load(data["image_path"])
		else: $Root/MapImage.texture = null
	else: $Root/MapImage.texture = null
	if "magnitude" in data: magnitude = data["magnitude"]
	if "image_scale" in data: image_scale = Vector2(data["image_scale"], data["image_scale"])
	if "image_rotation" in data: $Root/MapImage.rotation_degrees = data["image_rotation"]
	if "bg_color" in data: $Root.self_modulate = data["bg_color"]
	if "offset_x" in data: image_offset.x = data["offset_x"]
	if "offset_y" in data: image_offset.y = data["offset_y"]
	if "object_scale" in data: object_scale = data["object_scale"]

func _ready() -> void:
	modulate.a = 0.0
	$Root.clip_children = CLIP_CHILDREN_AND_DRAW
	$Root/MarkerBase.scale *= Vector2(0.5, 0.5)
	$Root/MarkerBase.position = size / 2.0
	
	Global.objects_loaded.connect(func():
		for o in Global.object_data:
			var o_node = $Root/ObjectBase/POI.duplicate()
			var pos = -Vector2(o.position.x, o.position.z)
			# o_node.position = pos * magnitude
			o_node.modulate.a = 0.0
			o_node.visible = true
			
			# Marker is always accurately tracked even when the point itself is constrained to the edge of the map
			var o_marker = Marker2D.new()
			# o_marker.position = pos * magnitude
			$Root/ObjectBase.add_child(o_node)
			$Root/ObjectBase.add_child(o_marker)
			objects.append({ "node": o_node, "marker": o_marker, "position": pos }))
	
	# Refresh map display. NOTE: this does not currently refresh objects
	Global.minimap_refresh.connect(update)
	
	# Hide the map while things lerp into place; then fade in
	# Because POIs are top-level, they need to be tweened independently
	# TODO: could get expensive if there are many POI calls
	await get_tree().create_timer(1.0).timeout
	var fade_tween = create_tween()
	fade_tween.tween_property(self, "modulate:a", 1.0, FADE_TIME)
	for o in objects:
		var f = create_tween()
		f.tween_property(o.node, "modulate:a", 1.0, FADE_TIME)

func _input(_event: InputEvent) -> void:
	# Handle zoom events
	if !Global.mouse_in_map: return
	if Input.is_action_just_pressed("zoom_in"): zoom += 0.1
	if Input.is_action_just_pressed("zoom_out"): zoom -= 0.1

func _process(delta: float) -> void:
	zoom = clamp(zoom, 0.5, 1.0)
	var offset = Vector2(
		Global.player_position.x * magnitude,
		Global.player_position.z * magnitude)
	$Root/MarkerBase.rotation = -CameraData.facing_angle
	
	$Root/MapImage.position = lerp(
		$Root/MapImage.position, size / 2.0 + (offset + image_offset) * zoom, delta * 10)
	$Root/MapImage.scale = lerp($Root/MapImage.scale, Vector2(zoom / 2.0, zoom / 2.0) * image_scale, delta * 10)
	$Root/ObjectBase.position = lerp($Root/ObjectBase.position, global_position + size / 2.0 + offset * zoom, delta * 10)
	$Root/ObjectBase.scale = lerp($Root/ObjectBase.scale, Vector2(zoom / 1.25, zoom / 1.25), delta * 10)
	
	# Constrain the object to the edge of the map if it goes out of bounds
	for o in objects:
		o.marker.position = o.position * magnitude * object_scale
		
		var dist = o.marker.global_position.distance_to($Root/MarkerBase.global_position)
		var angle = o.marker.global_position.angle_to_point($Root/MarkerBase.global_position)
		angle += deg_to_rad(180)
		if dist > 120:
			var restrain_pos = Vector2(cos(angle), sin(angle)) * 120
			o.node.global_position = $Root/MarkerBase.global_position + restrain_pos
		else: o.node.global_position = o.marker.global_position
	
	for node in $Root/ObjectBase.get_children():
		if node is Sprite2D:
			node.scale = lerp(node.scale, Vector2(1 / zoom, 1 / zoom), delta * 10)

# Checks to prevent camera orbiting when clicking in the map!
func _on_mouse_entered() -> void: Global.mouse_in_map = true
func _on_mouse_exited() -> void: Global.mouse_in_map = false
