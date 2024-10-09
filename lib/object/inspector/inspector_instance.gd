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
	$Transitions.play("fade_in")
	$Paper.play()

func _process(_delta: float) -> void:
	model_root.global_rotation_degrees.y = -$OrbitHandler.target_rotation.y

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		$Transitions.play_backwards("fade_in")
		$SmokeTransition.fade_out()
		await $Transitions.animation_finished
		_close()

func _close() -> void:
	Global.in_cutscene = false
	Global.player_can_move = true
	queue_free()
