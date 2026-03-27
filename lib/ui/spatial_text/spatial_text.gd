class_name SpatialText extends VisibleOnScreenNotifier3D

@export var text := "((Spatial Text))":
	set(_text):
		if label:
			text = _text
			update_text()
@export var debug_only := false

@onready var canvas := CanvasLayer.new()
@onready var root_2d := Control.new()
@onready var label := Label.new()

func update_text() -> void:
	label.text = text
	label.position.x = -label.size.x / 2.0

func _ready() -> void:
	Utils.debug_mode_changed.connect(func() -> void:
		if debug_only:
			canvas.visible = Utils.debug_mode)
	
	# Screen visibility change connections
	screen_entered.connect(func() -> void: root_2d.visible = true)
	screen_exited.connect(func() -> void: root_2d.visible = false)
	if !is_on_screen(): root_2d.visible = false
	
	# Configure text
	label.add_theme_constant_override("outline_size", 4)
	label.add_theme_font_override("font", load("res://generic/fonts/trebuchet.ttf"))
	label.add_theme_font_size_override("font_size", 14)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	# Configure other nodes
	aabb = AABB(Vector3(-0.1, -0.1, -0.1), Vector3(0.2, 0.2, 0.2))
	canvas.layer = -1
	root_2d.size = Vector2.ZERO
	
	# Add children
	add_child(canvas)
	canvas.add_child(root_2d)
	root_2d.add_child(label)
	
	# Finalise label text and anchors
	label.set_anchors_preset(Control.PRESET_CENTER)
	update_text()

func _process(_delta: float) -> void:
	if debug_only and !Utils.debug_mode: return
	if is_on_screen():
		var pos: Vector2 = Dwelt.camera.unproject_position(global_position)
		root_2d.global_position = pos
