class_name WorldText extends VisibleOnScreenNotifier3D
# world_text.gd
# Displays text at a certain 3D point on-screen

@export var initial_text = "Text"
@export var color = Color.WHITE
@export var distance_fade_start = 4.0
@export var distance_fade_end = 4.2

var label_offset = Vector2.ZERO

func track_node(node: Node) -> void:
	if node.get_parent() != null:
		node.reparent($Canvas/Label)
	else: $Canvas/Label.add_child(node)

func set_text(text: String) -> void:
	$Canvas/Label.text = "[center]" + text + "[/center]"

func _ready() -> void:
	label_offset.x = -$Canvas/Label.size.x / 2.0
	$Canvas/Label.modulate = color
	$Canvas.visible = false
	set_text(initial_text)

func _process(_delta: float) -> void:
	if !is_on_screen: return
	var screen_pos = CameraData.world_to_screen(global_position)
	$Canvas/Label.position = screen_pos + label_offset
	
	# Fade the text as the player moves further away from it
	var dist = global_position.distance_to(Global.player_position)
	var state
	if dist > distance_fade_end: state = 1
	elif dist > distance_fade_start and dist < distance_fade_end:
		state = (dist - distance_fade_start) / (distance_fade_end - distance_fade_start)
	else: state = 0
	
	if Global.in_cutscene: state += 1
	if !Global.debug_visible: state += 3
	$Canvas/Label.modulate.a = 1 - clamp(state, 0.0, 1.0)

func _on_screen_entered() -> void: $Canvas.visible = true
func _on_screen_exited() -> void: $Canvas.visible = false
