class_name SkillBar extends PanelContainer

func set_skill(index: int, skill_id: String) -> void:
	var _idx := 0 # current index
	# Iterate over skill buttons only so that we can include other node types
	# in the HBox (like padding ColorRects) and still apply to the right index
	for _n in $Box.get_children():
		if _n is SkillButton:
			if _idx == index:
				_n.skill_info = load(
					"res://skills/" + skill_id + "/" + skill_id + ".tres")
				break
			else: _idx += 1

func _ready() -> void:
	# Handle visibility and position of the button hover highlight effect
	for _n: Control in %Box.get_children():
		if _n is SkillButton:
			_n.mouse_entered.connect(func() -> void:
				%Highlight.visible = true
				%Highlight.position = _n.position + _n.size / 2.0)
			_n.mouse_exited.connect(func() -> void:
				%Highlight.visible = false)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_page_down"):
		# TODO: debug
		set_skill(3, "bingus_skill")
		set_skill(4, "test_skill")
