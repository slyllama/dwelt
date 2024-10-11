extends CanvasLayer
# Thingistry
# UI to show curios and curio collection progress

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

func _on_close_button_button_down() -> void:
	close()
