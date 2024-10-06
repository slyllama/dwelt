extends Node

var stopped = false
var fade_tween

func stop():
	stopped = true
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

func _ready() -> void:
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
	$CSCamera.position.y = 3.2
	var move_tween = create_tween()
	move_tween.tween_property(
		$CSCamera, "position:x", -1.35, 4.0).set_trans(Tween.TRANS_SINE)
	
	$FG/Bars.visible = true
	Global.hud_toggle_hidden.emit(true)
	Global.player_can_move = false

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("debug_key"):
		stop()

func _on_close_button_pressed() -> void:
	stop()
