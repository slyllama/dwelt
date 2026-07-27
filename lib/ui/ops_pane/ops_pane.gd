@tool
extends UIPane

func _ready() -> void:
	super()
	
	if Engine.is_editor_hint(): return
	
	# Nudge the pane up a little on open
	await get_tree().process_frame
	position.y -= 30.0
	
	var _gadget_subpane_loader := AsyncControlLoader.new()
	_gadget_subpane_loader.source_scene = "res://lib/ui/gadgets_subpane/gadgets_subpane.tscn"
	_gadget_subpane_loader.target_scene = %Body
	add_child(_gadget_subpane_loader)
