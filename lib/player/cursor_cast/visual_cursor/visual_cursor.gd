extends Node3D
# Visual indication of position of 3D cursor, mainly for selecting gadgets

func _ready() -> void:
	visible = false
	DwGlobal.tool_mode_changed.connect(func(new_tool_mode: DwGlobal.ToolMode) -> void:
		if new_tool_mode == DwGlobal.ToolMode.SELECT:
			visible = true
		else: visible = false)
