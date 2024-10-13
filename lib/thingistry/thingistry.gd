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

@onready var global_notif_icon = get_node("Base/Panel/VBox/HeadingBox/GlobalNotifIcon")
@onready var previous_button = get_node("Base/Panel/VBox/Navigation/PreviousButton")
@onready var next_button = get_node("Base/Panel/VBox/Navigation/NextButton")

var current_curio_position = Vector2(-300, 300)
var grid: CurioGrid
var _current_page = 0

func close() -> void:
	Curio.collected_since_last_open = [] # reset newly collected objects
	$Transitions.play_backwards("fade")
	await $Transitions.animation_finished
	Global.in_exclusive_ui = false
	Global.player_can_move = true
	queue_free()

# Switches the curio grid over to the indices which match the player's current page
func go_to_page(_page: int):
	$Paper.play()
	
	grid.clear()
	grid.generate(_page * grid.grid_size)
	for _button: CurioButton in grid.button_nodes:
		_button.clicked_button.connect(func(_pos):
			current_curio_position = _pos)
	current_curio_position = grid.button_nodes[0].get_center()
	$Base/Panel/VBox/Navigation/PageCount.text = ("[center]"
		+ str(_page + 1) + "/" + str(Curio.get_page_count(grid.grid_size))+ "[/center]")
	Curio.curio_selected.emit(grid.button_nodes[0].curio_id)
	
	# Toggle whether pagination buttons are enabled or not
	if _current_page == Curio.get_page_count(grid.grid_size) - 1:
		next_button.disabled = true
		next_button.mouse_filter = next_button.MOUSE_FILTER_IGNORE
	else:
		next_button.disabled = false
		next_button.mouse_filter = next_button.MOUSE_FILTER_STOP
	if _current_page == 0:
		previous_button.disabled = true
		previous_button.mouse_filter = next_button.MOUSE_FILTER_IGNORE
	else:
		previous_button.disabled = false
		previous_button.mouse_filter = next_button.MOUSE_FILTER_STOP

func _ready() -> void:
	grid = CurioGrid.new()
	grid_base.add_child(grid)
	
	if Engine.is_editor_hint(): return
	Global.in_exclusive_ui = true
	Global.player_can_move = false
	info_title.text = " "
	
	$Transitions.play("fade")
	$SmokeTransition.set_value(0.5)
	Curio.panel_opened.emit()
	
	# Fill in details when a curio is selected
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
			
			# Add additional text to information depending on which objects have been collected
			if "objects" in _data and "object_text" in _data:
				for _o in _data.objects:
					if _o in _data.object_text and _o in Curio.collected_objects:
						if info_body.text != "":
							# Only add a paragraph break if text came before it
							info_body.text += "\n\n"
						info_body.text += _data.object_text[_o]
			
			# Configure banner image
			info_banner.visible = true
			var banner_texture_path = Curio.TEXTURE_PATH + str(id) + "_banner.png"
			if ResourceLoader.exists(banner_texture_path):
				info_banner.texture = load(banner_texture_path) # TODO: parallelise?
			else: info_banner.texture = null
			
		else: # nothing is known yet about the curio and no information should be shown
			info_banner.texture = null
			info_title.text = ""
			info_body.text = ""
			info_progress.visible = false)
	
	go_to_page(0)
	
	# Set the active curio (and corresponding display data) to the first curio in the grid
	Curio.curio_selected.emit(grid.button_nodes[0].curio_id)
	
	if Curio.collected_since_last_open.size() > 0:
		global_notif_icon.visible = true
	else:
		global_notif_icon.visible = false
	
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

func _on_close_button_button_down() -> void: close()

func _on_next_button() -> void:
	# Advance the curio grid by a page, if there are more left
	if (_current_page + 1) * grid.grid_size < Curio.DATA.size():
		_current_page += 1
		go_to_page(_current_page)

func _on_previous_button() -> void:
	# Go back a curio grid page, if you're not already at the beginning
	if _current_page > 0:
		_current_page -= 1
		go_to_page(_current_page)

func _on_button_mouse_entered() -> void:
	# Connect other buttons here so that they will make the sound
	Global.hover_sound.emit()
