class_name SkillBar
extends PanelContainer

func _ready() -> void:
	# Handle visibility and position of the button hover highlight effect
	for _n: Control in %Box.get_children():
		if _n is SkillButton:
			_n.released.connect(func() -> void: print(_n.name))
			_n.mouse_entered.connect(func() -> void:
				%Highlight.visible = true
				%Highlight.position = _n.position + _n.size / 2.0)
			_n.mouse_exited.connect(func() -> void:
				%Highlight.visible = false)
