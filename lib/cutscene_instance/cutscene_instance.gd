class_name CutsceneInstance extends Node

var stopped = false
var fade_tween

@export var camera_rotation_degrees := Vector3.ZERO
@export var camera_original_position := Vector3.ZERO
@export var camera_target_position := Vector3.ZERO
@export var camera_animation_speed := 4.0
@export var dialogue_script: Array[String] = []

func stop():
	stopped = true
	$Dialogue.queue_free() # TODO: temp only
	$SmokeTransition.fade_out(0.5)
	
	fade_tween = create_tween()
	fade_tween.tween_property($FG/Fade, "modulate:a", 1.0, 0.5)
	await fade_tween.finished
	
	# Default state actions go here
	CameraData.camera.make_current()
	Global.hud_toggle_hidden.emit(false)
	Global.player_can_move = true
	$FG/Bars.visible = false
	
	Global.in_cutscene = false
	fade_tween = create_tween()
	fade_tween.tween_property($FG/Fade, "modulate:a", 0.0, 0.5)
	await fade_tween.finished
	
	queue_free()

func play() -> void:
	Global.in_cutscene = true
	$FG/Fade.modulate.a = 0.0
	fade_tween = create_tween()
	fade_tween.tween_property($FG/Fade, "modulate:a", 1.0, 0.5)
	if stopped: return
	await fade_tween.finished
	
	fade_tween = create_tween()
	fade_tween.tween_property($FG/Fade, "modulate:a", 0.0, 0.5)
	$SmokeTransition.visible = true
	$SmokeTransition.set_value(0.5)
	
	# Cutscene actions go here
	$CSCamera.make_current()
	$CSCamera.position = camera_original_position
	$CSCamera.rotation_degrees = camera_rotation_degrees
	var move_tween = create_tween()
	move_tween.tween_property(
		$CSCamera, "position", camera_original_position + camera_target_position,
		camera_animation_speed).set_trans(Tween.TRANS_SINE)
	
	if dialogue_script.size() > 0:
		$Dialogue.play(dialogue_script)
	
	$FG/Bars.visible = true
	Global.hud_toggle_hidden.emit(true)
	Global.player_can_move = false

func _ready() -> void:
	play()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("test_action"):
		stop()

func _hover() -> void: Global.hover_sound.emit()

func _on_close_button_pressed() -> void:
	Global.click_sound.emit()
	stop()
