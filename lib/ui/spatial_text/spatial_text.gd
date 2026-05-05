@tool
class_name SpatialText extends VisibleOnScreenNotifier3D

const TICK := 0.6

@export var text := "((Spatial Text))"
@export var render_distance := 20.0
@export var debug_only := false

@onready var canvas := CanvasLayer.new()
@onready var root_2d := Control.new()
@onready var label := Label.new()

var visibility_state := false

func handle_visibility() -> void:
	var _dist_to_player := global_position.distance_to(Dwelt.player.global_position)
	if _dist_to_player > render_distance and visibility_state == true:
		visibility_state = false
		
		await get_tree().process_frame # give it a frame to let the position update
		var _t := create_tween()
		_t.tween_property(label, "modulate:a", 0.0, 0.3)
		_t.tween_callback(func() -> void:
			if visibility_state == false:
				label.visible = false)
	elif _dist_to_player <= render_distance and visibility_state == false:
		visibility_state = true
		label.visible = true
		var _t := create_tween()
		_t.tween_property(label, "modulate:a", 1.0, 0.3)

func _ready() -> void:
	aabb = AABB(Vector3(-0.1, -0.1, -0.1), Vector3(0.2, 0.2, 0.2))
	
	if Engine.is_editor_hint(): return
	Utils.debug_mode_changed.connect(func() -> void:
		if debug_only:
			canvas.visible = Utils.debug_mode)
	
	# Screen visibility change connections
	screen_entered.connect(func() -> void: root_2d.visible = true)
	screen_exited.connect(func() -> void: root_2d.visible = false)
	if !is_on_screen(): root_2d.visible = false
	
	# Configure text
	label.add_theme_constant_override("outline_size", 4)
	label.add_theme_font_override("font", load("res://generic/fonts/amarante.ttf"))
	label.add_theme_font_size_override("font_size", 17)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.visible = false
	
	# Configure other nodes
	canvas.layer = -1
	root_2d.size = Vector2.ZERO
	
	# Add children
	add_child(canvas)
	canvas.add_child(root_2d)
	root_2d.add_child(label)
	
	# Finalise label text and anchors
	label.set_anchors_preset(Control.PRESET_CENTER)
	
	# Process this again (for late-comers)
	await get_tree().process_frame
	label.text = text
	if debug_only: canvas.visible = Utils.debug_mode

var _c := TICK

func _process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	if debug_only and !Utils.debug_mode: return
	if is_on_screen() and label.visible:
		var pos: Vector2 = Dwelt.camera.unproject_position(global_position)
		root_2d.global_position = pos
		label.position.x = -label.size.x / 2.0
	_c -= delta
	if _c <= 0.0:
		_c = TICK
		handle_visibility()
