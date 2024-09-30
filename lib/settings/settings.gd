extends Panel
# Settings

const TRANS_TIME = 0.11
var is_open = false

@onready var current_position = position
var last_mouse_title_click = Vector2.ZERO
var mouse_in_title = false
var moving_window = false

func open():
	if is_open: return
	
	is_open = true
	visible = true
	var open_tween = create_tween()
	open_tween.tween_property(self, "modulate:a", 1.0, TRANS_TIME)

func close():
	if !is_open: return
	
	is_open = false
	var close_tween = create_tween()
	close_tween.tween_property(self, "modulate:a", 0.0, TRANS_TIME)
	close_tween.tween_callback(func():
		if !is_open: visible = false)

func _ready():
	visible = false
	modulate.a = 0.0
	
	# Update panel position on window resize to avoid jumping
	get_window().size_changed.connect(func():
		current_position = position)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_click"):
		if mouse_in_title:
			last_mouse_title_click = get_window().get_mouse_position()
			moving_window = true
	if Input.is_action_just_released("left_click"):
		moving_window = false
		current_position = position

func _on_mouse_entered() -> void: Global.mouse_in_settings = true
func _on_mouse_exited() -> void: Global.mouse_in_settings = false

func _on_title_mouse_entered() -> void: mouse_in_title = true
func _on_title_mouse_exited() -> void: mouse_in_title = false

func _process(delta: float) -> void:
	if moving_window:
		var mouse_delta = get_window().get_mouse_position() - last_mouse_title_click
		position = current_position + mouse_delta
