extends CanvasLayer
# Thingistry
# UI to show curios and curio collection progress

const BANNER_NO_IMAGE = preload("res://lib/thingistry/curio_button/textures/curio_test_banner.png")

# Quick links to deeply nested ndoes
@onready var grid_base = get_node("Base/Panel/VBox/BodyBox/GridBase")
@onready var info_base = get_node("Base/Panel/VBox/BodyBox/Infobase")
@onready var info_title = get_node("Base/Panel/VBox/BodyBox/Infobase/VBox/Title")
@onready var info_progress = get_node("Base/Panel/VBox/BodyBox/Infobase/VBox/Progress")
@onready var info_banner = get_node("Base/Panel/VBox/BodyBox/Image")
@onready var info_body = get_node("Base/Panel/VBox/BodyBox/Infobase/VBox/Body")

var current_curio_position = Vector2(-300, 300)

func close() -> void:
	Global.in_exclusive_ui = false
	Global.player_can_move = true
	Curio.collected_since_last_open = [] # reset newly collected objects
	$Transitions.play_backwards("fade")
	await $Transitions.animation_finished
	
	queue_free()

func _ready() -> void:
	Global.in_exclusive_ui = true
	Global.player_can_move = false
	info_title.text = " "
	$Transitions.play("fade")
	Curio.panel_opened.emit()
	
	Curio.curio_selected.connect(func(id):
		var _progress = Curio.get_progress(id)
		if _progress > 0:
			# Display information - something is known about the curio
			info_title.text = Curio.DATA[id].name
			info_body.text = ("((Short introductory information about this curio, '"
				+ id + "'. This information displays at the top of the info panel.))")
			info_progress.value = _progress * 100
			
			info_banner.visible = true
			var banner_texture_path = Curio.TEXTURE_PATH + "curio_" + str(id) + "_banner.png"
			if ResourceLoader.exists(banner_texture_path):
				info_banner.texture = load(banner_texture_path) # TODO: parallelise?
			else: # couldn't find the image - go to default
				info_banner.texture = BANNER_NO_IMAGE
			
		else:
			# Nothing is known yet about the curio and no information should be shown
			info_banner.visible = false
			info_title.text = "((???))"
			info_body.text = ("((???))")
			info_progress.value = 0)
	
	var grid = CurioGrid.new()
	grid_base.add_child(grid)
	grid.generate(0)
	
	for _button: CurioButton in grid.button_nodes:
		_button.clicked_button.connect(func(_pos):
			current_curio_position = _pos)
	
	# Set the active curio (and corresponding display data) to the first curio
	# in the grid
	Curio.curio_selected.emit(grid.button_nodes[0].curio_id)
	
	# Get new node positions when window changes - resizing can leave the cursor
	# off in the middle of nowhere
	get_window().size_changed.connect(func():
		current_curio_position = grid.button_nodes[0].get_center()
		$Cursor.global_position = current_curio_position)
	
	await get_tree().process_frame # needs a chance to know its true global position
	current_curio_position = grid.button_nodes[0].get_center()
	$Cursor.global_position = current_curio_position

func _process(delta: float) -> void:
	$Cursor.global_position = lerp(
		$Cursor.global_position, current_curio_position, delta * 20)

func _on_close_button_button_down() -> void:
	close()
