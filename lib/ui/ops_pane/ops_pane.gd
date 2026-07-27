@tool
extends UIPane

func _ready() -> void:
	super()
	
	if Engine.is_editor_hint(): return
	
	# Nudge the pane up a little on open
	await get_tree().process_frame
	position.y -= 30.0
