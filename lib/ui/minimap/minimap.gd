extends Panel

@onready var center := size / 2.0
var magnitude = 10.0
var retina_scale = 1

func _ready() -> void:
	visible = true
	clip_contents = true
	# Double everything for retina (or halve scales)
	if get_window().size.x > 2000:
		retina_scale *= 2
	$MapRoot/MapImage.position = center * retina_scale
	$MapRoot/Character.position = center * retina_scale
	$MapRoot.scale = Vector2(1.0 / retina_scale, 1.0 / retina_scale)
	
	Global.objects_loaded.connect(func():
		for o in Global.object_data:
			var p = $MapRoot/MapImage/POI.duplicate()
			var pos = Vector2(o.position.x, o.position.z) # strip Y
			p.visible = true
			p.position = Vector2(
				-pos.x * magnitude * retina_scale,
				-pos.y * magnitude * retina_scale)
			$MapRoot/MapImage.add_child(p))

func _input(_event: InputEvent) -> void:
	if !Global.mouse_in_map: return
	# Zoom functions go here

func _process(_delta: float) -> void:
	var offset = Vector2(
		Global.player_position.x * magnitude,
		Global.player_position.z * magnitude)
	$MapRoot/MapImage.position = center * retina_scale + offset * retina_scale
	$MapRoot/Character.rotation_degrees = -Global.player_y_rotation
	
	# Debug
	$DebugText.text = (str(Utilities.fmt_vec2(offset * retina_scale))
		+ " at " + str(snapped($MapRoot/Character.rotation_degrees, 1.0)) + "deg")
	$DebugText.text += "\nmagnitude = " + str(snapped(magnitude, 0.1))

# Checks to prevent camera orbiting when clicking in the map!
func _on_mouse_entered() -> void: Global.mouse_in_map = true
func _on_mouse_exited() -> void: Global.mouse_in_map = false
