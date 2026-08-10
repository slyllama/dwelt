extends GPUParticles2D

func _ready() -> void:
	DwGlobal.tool_mode_changed.connect(func(new_tool_mode: DwGlobal.ToolMode) -> void:
		if new_tool_mode == DwGlobal.ToolMode.SELECT:
			emitting = true
			await get_tree().create_timer(0.2).timeout
			if emitting: lifetime = 2.0
		else:
			lifetime = 0.6
			emitting = false)
