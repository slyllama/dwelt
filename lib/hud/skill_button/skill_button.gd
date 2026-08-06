@icon("res://generic/icons/SkillButton.svg")
class_name SkillButton extends Control

const DIM := 0.8 # dim strength
const PLACEHOLDER_ICON_PATH := "res://lib/hud/skill_button/textures/placeholder.jpg"

@export var input_binding: String
@export var skill_info: SkillInfo:
	set(_skill_info):
		skill_info = _skill_info
		apply_skill()

signal released

var is_pressed := false
var is_hovering := false

#region Input functions
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

# Visually apply a skill change, run when skill_info is changed
func apply_skill() -> void:
	if skill_info:
		if skill_info.icon: %Icon.update_icon(skill_info.icon)
		else: %Icon.update_icon(load(PLACEHOLDER_ICON_PATH))
	else: %Icon.update_icon() # clear icon

func set_pressed(state := true) -> void:
	is_pressed = state
	if is_pressed: %Content.modulate = Color(DIM, DIM, DIM)
	else: %Content.modulate = Color(1.0, 1.0, 1.0)
#endregion

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_page_down"): # TODO: debug
		apply_skill()
	
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
		if (Input.is_action_pressed("left_click")
			and is_hovering):
			pass
		else:
			set_pressed()
	elif is_binding_just_released():
		if is_pressed:
			if (Input.is_action_pressed("left_click")
				and is_hovering):
				pass
			else:
				released.emit()
				set_pressed(false)

func _on_mouse_exited() -> void:
	set_pressed(false)
	is_hovering = false

func _on_mouse_entered() -> void:
	is_hovering = true

func _on_released() -> void:
	if skill_info:
		#DwUtils.pdebug("Used skill '"
			#+ skill_info.title + "'.", "SkillButton")
		DwGlobal.skill_used.emit(skill_info.id)
