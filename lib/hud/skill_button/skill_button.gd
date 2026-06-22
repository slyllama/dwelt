@icon("res://generic/icons/SkillButton.svg")
class_name SkillButton extends Control

const DIM := 0.75 # dim strength

@export var input_binding: String

signal released

var is_pressed := false
var is_hovering := false

func is_binding_pressed() -> bool:
	if input_binding in InputMap.get_actions():
		return(Input.is_action_pressed(input_binding))
	else: return(false)

func is_binding_just_pressed() -> bool:
	if input_binding in InputMap.get_actions():
		return(Input.is_action_just_pressed(input_binding))
	else: return(false)

func is_binding_just_released() -> bool:
	if input_binding in InputMap.get_actions():
		return(Input.is_action_just_released(input_binding))
	else: return(false)

func set_pressed(state := true) -> void:
	is_pressed = state
	if is_pressed: %Content.modulate = Color(DIM, DIM, DIM)
	else: %Content.modulate = Color(1.0, 1.0, 1.0)

func _input(_event: InputEvent) -> void:
	if get_window().gui_get_focus_owner() is LineEdit:
		set_pressed(false)
		return
	
	# Handle mouse pressing
	if (Input.is_action_just_pressed("left_click")
		and is_hovering):
		if !is_binding_pressed():
			set_pressed()
	elif Input.is_action_just_released("left_click"):
		if is_pressed:
			if !is_binding_pressed():
				released.emit()
		set_pressed(false)
	
	# Handle input action pressing
	if is_binding_just_pressed():
		if !Input.is_action_pressed("left_click"):
			set_pressed()
	elif is_binding_just_released():
		if is_pressed:
			if !Input.is_action_pressed("left_click"):
				released.emit()
		set_pressed(false)

func _on_mouse_exited() -> void:
	set_pressed(false)
	is_hovering = false

func _on_mouse_entered() -> void:
	is_hovering = true
