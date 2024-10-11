extends CanvasLayer
# Thingistry
# UI to show curios and curio collection progress

@onready var grid_base = get_node("Base/Panel/VBox/BodyBox/GridBase")
@onready var curio_info_title = get_node("Base/Panel/VBox/BodyBox/Infobase/VBox/Title")

func close() -> void:
	Global.in_exclusive_ui = false
	Global.player_can_move = true
	$Transitions.play_backwards("fade")
	await $Transitions.animation_finished
	
	queue_free()

func _ready() -> void:
	Global.in_exclusive_ui = true
	Global.player_can_move = false
	curio_info_title.text = " "
	$Transitions.play("fade")
	
	var grid = CurioGrid.new()
	grid_base.add_child(grid)
	grid.generate(1)
	
	Curio.curio_hovered.connect(func(id):
		curio_info_title.text = Curio.DATA[id].name)

func _on_close_button_button_down() -> void:
	close()
