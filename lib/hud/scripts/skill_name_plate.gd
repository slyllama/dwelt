extends TextureRect

func _init() -> void:
	visible = false

func _ready() -> void:
	DwGlobal.skill_used.connect(func(_skill_id: String) -> void:
		# Clear this tooltip when a skill is changed (to prevent them lingering when hovered)
		# TODO: could be handled better
		visible = false)

func _on_hovered_skill_changed(skill_info: SkillInfo) -> void:
	if skill_info:
		visible = true
		%SkillTitle.text = skill_info.title
	else: visible = false
