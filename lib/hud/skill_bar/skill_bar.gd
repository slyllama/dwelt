class_name SkillBar extends PanelContainer

signal hovered_skill_changed(skill_info: SkillInfo)

func set_skill(index: int, skill_id: String) -> void:
	var _idx := 0 # current index
	# Iterate over skill buttons only so that we can include other node types
	# in the HBox (like padding ColorRects) and still apply to the right index
	for _n in $Box.get_children():
		if _n is SkillButton:
			if _idx == index:
				_n.skill_info = load(
					"res://data/skills/" + skill_id + "/" + skill_id + ".tres")
				break
			else: _idx += 1

func clear_all_skills() -> void:
	for _n: Control in $Box.get_children():
		if _n is SkillButton:
			_n.skill_info = null

func apply_default_skills() -> void:
	clear_all_skills()
	set_skill(0, "interact")
	set_skill(1, "build")
	set_skill(2, "cleanse")

func enter_cancel_state() -> void:
	clear_all_skills()
	set_skill(9, "cancel")

func handle_tool_change(_new_tool_mode: DwGadget.ToolMode) -> void:
	if DwGadget.is_in_selection_mode():
		enter_cancel_state()

func handle_skill_use(skill_id: String) -> void:
	if skill_id == "cancel":
		apply_default_skills()

func _ready() -> void:
	DwGadget.tool_mode_changed.connect(handle_tool_change)
	DwGlobal.skill_used.connect(handle_skill_use)
	
	# Handle visibility and position of the button hover highlight effect
	for _n: Control in %Box.get_children():
		if _n is SkillButton:
			_n.mouse_entered.connect(func() -> void:
				hovered_skill_changed.emit(_n.skill_info)
				%Highlight.visible = true
				%Highlight.position = _n.position + _n.size / 2.0)
			_n.mouse_exited.connect(func() -> void:
				hovered_skill_changed.emit(null)
				%Highlight.visible = false)
