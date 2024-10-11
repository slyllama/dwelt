extends CanvasLayer
# Thingistry
# UI to show curios and curio collection progress

@onready var grid_base = get_node("Base/Panel/VBox/BodyBox/GridBase")

func close() -> void:
	Global.in_exclusive_ui = false
	Global.player_can_move = true
	$Transitions.play_backwards("fade")
	await $Transitions.animation_finished
	
	queue_free()

func _ready() -> void:
	Global.in_exclusive_ui = true
	Global.player_can_move = false
	$Transitions.play("fade")
	
	var _g = CurioGrid.new()
	grid_base.add_child(_g)

func _on_close_button_button_down() -> void:
	close()
