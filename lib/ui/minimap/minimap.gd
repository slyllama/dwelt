extends TextureRect

var magnitude := 11.0
var zoom := 1.0
# Assume all sprites are 1/2th scale by default

func _ready() -> void:
	clip_children = CLIP_CHILDREN_AND_DRAW
	$MarkerBase.scale *= Vector2(0.5, 0.5)
	$MarkerBase.position = size / 2.0

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
	$MarkerBase.rotation = -CameraData.facing_angle
	$MapImage.position = lerp(
		$MapImage.position, size / 2.0 + offset * zoom, delta * 10)
	$MapImage.scale = lerp(
		$MapImage.scale, Vector2(zoom / 2.0, zoom / 2.0), delta * 10)

# Checks to prevent camera orbiting when clicking in the map!
func _on_mouse_entered() -> void: Global.mouse_in_map = true
func _on_mouse_exited() -> void: Global.mouse_in_map = false
