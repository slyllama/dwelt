extends TextureRect

func _init() -> void:
	visible = false

func _on_hovered_skill_changed(skill_info: SkillInfo) -> void:
	if skill_info:
		visible = true
		%SkillTitle.text = skill_info.title
	else: visible = false
