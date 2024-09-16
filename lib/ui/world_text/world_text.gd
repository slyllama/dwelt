extends VisibleOnScreenNotifier3D
# world_text.gd
# Displays text at a certain 3D point on-screen

@export var initial_text = "Text"
@export var color = Color.WHITE

var label_offset = Vector2.ZERO

func set_text(text):
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

func _on_screen_entered() -> void: $Canvas.visible = true
func _on_screen_exited() -> void: $Canvas.visible = false
