@tool
extends CanvasLayer
# Thingistry
# UI to show curios and curio collection progress

# Quick links to deeply nested ndoes
@onready var grid_base = get_node("Base/Panel/VBox/BodyBox/GridBase")
@onready var info_base = get_node("Base/Panel/VBox/BodyBox/Infobase")
@onready var info_title = get_node("Base/Panel/VBox/BodyBox/Infobase/VBox/Title")
@onready var info_progress = get_node("Base/Panel/VBox/BodyBox/Infobase/VBox/Progress")
@onready var info_banner = get_node("Base/Panel/VBox/BodyBox/Image")
@onready var info_body = get_node("Base/Panel/VBox/BodyBox/Infobase/VBox/Body")

var current_curio_position = Vector2(-300, 300)

func close() -> void:
	Curio.collected_since_last_open = [] # reset newly collected objects
	$Transitions.play_backwards("fade")
	await $Transitions.animation_finished
	Global.in_exclusive_ui = false
	Global.player_can_move = true
	
	queue_free()

func _ready() -> void:
	var grid = CurioGrid.new()
	grid_base.add_child(grid)
	
	if Engine.is_editor_hint(): return
	grid.generate(0)
	
	Global.in_exclusive_ui = true
	Global.player_can_move = false
	info_title.text = " "
	$Transitions.play("fade")
	$SmokeTransition.set_value(0.5)
	Curio.panel_opened.emit()
	
	Curio.curio_selected.connect(func(id):
		var _progress = Curio.get_progress(id)
		var _data = Curio.DATA[id]
		if _progress > 0:
			# Display information - something is known about the curio
			info_title.text = _data.name
			if "short_desc" in _data:
				info_body.text = _data.short_desc
			info_progress.visible = visible
			info_progress.value = _progress * 100
			
			info_banner.visible = true
			var banner_texture_path = Curio.TEXTURE_PATH + str(id) + "_banner.png"
			if ResourceLoader.exists(banner_texture_path):
				info_banner.texture = load(banner_texture_path) # TODO: parallelise?
			
		else: # nothing is known yet about the curio and no information should be shown
			info_banner.visible = false
			info_title.text = ""
			info_body.text = ""
			info_progress.visible = false)
	
	for _button: CurioButton in grid.button_nodes:
		_button.clicked_button.connect(func(_pos):
			current_curio_position = _pos)
	
	# Set the active curio (and corresponding display data) to the first curio in the grid
	Curio.curio_selected.emit(grid.button_nodes[0].curio_id)
	
	# Get new node positions when window changes - resizing can leave the cursor
	# off in the middle of nowhere
	get_window().size_changed.connect(func():
		current_curio_position = grid.button_nodes[0].get_center()
		$Cursor.global_position = current_curio_position)
	
	await get_tree().process_frame # needs a chance to know its true global position
	current_curio_position = grid.button_nodes[0].get_center()
	$Cursor.global_position = current_curio_position

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("thingistry"):
		close()

func _process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	$Cursor.global_position = lerp(
		$Cursor.global_position, current_curio_position, delta * 20)

func _on_close_button_button_down() -> void:
	close()
