extends CanvasLayer
# Thingistry
# UI to show curios and curio collection progress

# Quick links to deeply nested ndoes
@onready var grid_base = get_node("Base/Panel/VBox/BodyBox/GridBase")
@onready var info_base = get_node("Base/Panel/VBox/BodyBox/Infobase")
@onready var info_title = get_node("Base/Panel/VBox/BodyBox/Infobase/VBox/Title")
@onready var info_progress = get_node("Base/Panel/VBox/BodyBox/Infobase/VBox/Progress")
@onready var info_body = get_node("Base/Panel/VBox/BodyBox/Infobase/VBox/Body")

var current_curio_position = Vector2(-300, 300)

func close() -> void:
	Global.in_exclusive_ui = false
	Global.player_can_move = true
	$Transitions.play_backwards("fade")
	await $Transitions.animation_finished
	
	queue_free()

func _ready() -> void:
	Global.in_exclusive_ui = true
	Global.player_can_move = false
	info_title.text = " "
	$Transitions.play("fade")
	
	Curio.curio_selected.connect(func(id):
		var _progress = Curio.get_progress(id)
		if _progress > 0:
			info_title.text = Curio.DATA[id].name
			info_body.text = ("((Short introductory information about this curio, '"
				+ id + "'. This information displays at the top of the info panel.))")
			info_progress.value = _progress * 100
		else:
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
	
	await get_tree().process_frame # needs a chance to know its true global position
	current_curio_position = grid.button_nodes[0].get_center()
	$Cursor.global_position = current_curio_position

func _process(delta: float) -> void:
	$Cursor.global_position = lerp(
		$Cursor.global_position, current_curio_position, delta * 20)

func _on_close_button_button_down() -> void:
	close()
