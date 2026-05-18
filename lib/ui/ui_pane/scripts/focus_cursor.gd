extends Sprite2D

var pane_focus_target: Control
@onready var target_position := global_position

func update_cursor_target() -> void:
	target_position = pane_focus_target.global_position
	target_position.y += pane_focus_target.size.y * 0.5
	if pane_focus_target is CheckButton:
		target_position.x += pane_focus_target.size.x - 16.0
	elif pane_focus_target is Button or pane_focus_target is HSlider:
		target_position.x += pane_focus_target.size.x * 0.5

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	if DweltInput.current_device_mode != DweltInput.DeviceModes.CONTROLLER:
		visible = false
		return
	
	# Handle the position of the pane focus target
	# Includes some custom rules for various types of Control
	if pane_focus_target:
		visible = true
		update_cursor_target()
		global_position = lerp(global_position, target_position, Utils.crit_plerp(40.0))
	else: visible = false
