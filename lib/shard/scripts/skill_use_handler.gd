extends Node
# SkillUseHandler
# Receives skill use signals and directs them to the appropriate place.
# (Mainly just for organization purposes. Remember that skill use signals can
# (and will) cascade in multiple places - for example a lot of these skill here
# will enter the skill bar into a "cancel" state, and that is handled in that
# node, not here. WARNING: be aware of race conditions and what order things
# are happening in.

#region Skill functions
func on_interact() -> void:
	DwGlobal.change_tool_mode(DwGlobal.ToolMode.SELECT)

func on_cancel() -> void:
	DwGlobal.change_tool_mode(DwGlobal.ToolMode.NORMAL)
#endregion

func handle_skill(skill_id: String) -> void: # function always has this name
	match skill_id:
		"interact": on_interact()
		"cancel": on_cancel()
		_: pass # nothing recognizable happened

func _ready() -> void:
	DwGlobal.skill_used.connect(handle_skill)
