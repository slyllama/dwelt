class_name CutsceneInstance extends Node
# CutsceneInstance
# Spawns a cutscene which takes over the screen, playing dialogue and following
# a pre-set camera animation
const HINT = "[Alt] Rotate  [Shift] Raise/Lower  [LMB] Fine-Tune"

signal finished
var has_stopped = false
var fade_tween: Tween
var move_tween: Tween

@export var camera_rotation_degrees := Vector3.ZERO
@export var camera_original_position := Vector3.ZERO
@export var camera_target_position := Vector3.ZERO
@export var camera_animation_speed := 4.0
@export var dialogue_script: Array[String] = []

func stop() -> void:
	if has_stopped: return # no double-ups
	
	has_stopped = true
	$FG/Bars/Upper/CloseButton.queue_free()
	$Dialogue.queue_free() # TODO: temp only
	$SmokeTransition.fade_out(0.5)
	
	fade_tween = create_tween()
	fade_tween.tween_property($FG/Fade, "modulate:a", 1.0, 0.5)
	await fade_tween.finished
	
	# Default state actions go here
	CameraData.camera.make_current()
	Global.hud_toggle_hidden.emit(false)
	Global.player_can_move = true
	Global.interaction_ended.emit()
	$FG/Bars.visible = false
	
	Global.in_exclusive_ui = false
	fade_tween = create_tween()
	fade_tween.tween_property($FG/Fade, "modulate:a", 0.0, 0.5)
	await fade_tween.finished
	
	queue_free()

func play() -> void:
	Global.in_exclusive_ui = true
	$FG/Fade.modulate.a = 0.0
	$FG/Bars.visible = false
	fade_tween = create_tween()
	fade_tween.tween_property($FG/Fade, "modulate:a", 1.0, 0.5)
	if has_stopped: return
	await fade_tween.finished
	
	fade_tween = create_tween()
	fade_tween.tween_property($FG/Fade, "modulate:a", 0.0, 0.5)
	
	$SmokeTransition.visible = true
	$FG/Bars.visible = true
	$SmokeTransition.set_value(0.5)
	
	# Cutscene actions go here
	$CSCamera.make_current()
	$CSCamera.position = camera_original_position
	$CSCamera.rotation_degrees = camera_rotation_degrees
	
	# Don't play any animation if the animation time is set to zero - good for
	# static cutscenes and debugging
	if camera_animation_speed > 0:
		move_tween = create_tween()
		move_tween.tween_property(
			$CSCamera, "position", camera_target_position,
			camera_animation_speed).set_trans(Tween.TRANS_SINE)
		move_tween.tween_callback(finished.emit)
	
	if dialogue_script.size() > 0:
		$Dialogue.play(dialogue_script)
	
	$FG/Bars.visible = true
	Global.hud_toggle_hidden.emit(true)
	Global.player_can_move = false

func _toggle_debug() -> void:
	$FG/Bars/DebugText.visible = Global.debug_visible
	$FG/Bars/Upper/Print.visible = Global.debug_visible
	$FG/Bars/Upper/Stop.visible = Global.debug_visible

func _ready() -> void:
	_toggle_debug()
	$FG/Fade.visible = true
	Global.debug_visible_toggled.connect(_toggle_debug)
	play()

const SENSITIVITY = 2.0
var _sn: float = SENSITIVITY

func _process(delta: float) -> void:
	if !Global.debug_visible: return
	
	# Print camera position
	$FG/Bars/DebugText.text = HINT
	$FG/Bars/DebugText.text += (str("\nCamera position: ") + Utilities.fmt_vec3($CSCamera.global_position))
	$FG/Bars/DebugText.text += (str("\nCamera rotation (degrees): ") + Utilities.fmt_vec3($CSCamera.global_rotation_degrees))
	
	# Allows for manipulating the camera and printing its updated position and
	# rotation while in debug mode
	_sn = SENSITIVITY
	if Input.is_action_pressed("left_click"): _sn /= 2.0
	if Input.is_action_pressed("jump"):
		if Input.is_action_pressed("move_left"): 
			$CSCamera.rotation.y += delta * _sn
		if Input.is_action_pressed("move_right"):
			$CSCamera.rotation.y -= delta * _sn
		if Input.is_action_pressed("move_forward"):
			$CSCamera.rotation.x += delta * _sn
		if Input.is_action_pressed("move_back"):
			$CSCamera.rotation.x -= delta * _sn
	
	elif Input.is_action_pressed("test_action"): # shift
		if Input.is_action_pressed("move_forward"):
			$CSCamera.position.y += delta * _sn
		if Input.is_action_pressed("move_back"):
			$CSCamera.position.y -= delta * _sn
	
	else:
		if Input.is_action_pressed("move_left"):
			$CSCamera.position -= Vector3.LEFT * delta * $CSCamera.global_basis * Vector3(-1, 0, 1) * _sn
		if Input.is_action_pressed("move_right"):
			$CSCamera.position -= Vector3.RIGHT * delta * $CSCamera.global_basis * Vector3(-1, 0, 1) * _sn
		if Input.is_action_pressed("move_forward"):
			$CSCamera.position -= Vector3.FORWARD * delta * $CSCamera.global_basis * Vector3(1, 0, -1) * _sn
		if Input.is_action_pressed("move_back"):
			$CSCamera.position -= Vector3.BACK * delta * $CSCamera.global_basis * Vector3(1, 0, -1) * _sn

func _hover() -> void:
	Global.hover_sound.emit()

func _on_close_button_pressed() -> void:
	Global.click_sound.emit()
	stop()

func _on_print_pressed() -> void:
	print("position = Vector3(" + Utilities.fmt_vec3($CSCamera.global_position) + ")")
	print("rotation_degrees = Vector3(" + Utilities.fmt_vec3($CSCamera.global_rotation_degrees) + ")")

func _on_stop_pressed() -> void:
	move_tween.kill()
