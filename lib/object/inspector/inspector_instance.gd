class_name InspectorInstance extends CanvasLayer
# InspectorInstance
# Displays an object on the screen which can be manipulated and observed

func _ready() -> void:
	Global.in_cutscene = true
	Global.player_can_move = false
	
	$SmokeTransition.visible = true
	$SmokeTransition.set_value(0.5)

func _process(_delta: float) -> void:
	$Box3D/Viewport/InspectorWorld/Box.rotation_degrees = -$OrbitHandler.target_rotation

func _on_close_button_pressed() -> void:
	Global.in_cutscene = false
	Global.player_can_move = true
	queue_free()
