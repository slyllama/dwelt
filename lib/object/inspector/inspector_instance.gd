class_name InspectorInstance extends CanvasLayer
# InspectorInstance
# Displays an object on the screen which can be manipulated and observed
@onready var model_root = get_node("Box3D/Viewport/InspectorWorld/ModelRoot")

func _ready() -> void:
	# A restricting has already been initiated and so the inspector is
	#ineligible
	if !Global.player_can_move or Global.in_cutscene:
		queue_free()
		return
	
	Global.in_cutscene = true
	Global.player_can_move = false
	$SmokeTransition.visible = true
	$SmokeTransition.set_value(0.5)

func _process(_delta: float) -> void:
	model_root.global_rotation_degrees.y = -$OrbitHandler.target_rotation.y

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		# Dirty trick to prevent the inspector from re-opening instantly
		await get_tree().process_frame
		_close()

func _close() -> void:
	Global.in_cutscene = false
	Global.player_can_move = true
	queue_free()
