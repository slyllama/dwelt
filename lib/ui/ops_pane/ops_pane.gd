@tool
extends UIPane

func _ready() -> void:
	super()
	
	if Engine.is_editor_hint(): return
	
	# Nudge the pane up a little on open
	await get_tree().process_frame
	position.y -= 30.0
	$Bell.play() # additional little opening tone

func _on_closing() -> void:
	if randf() < 0.5: # a 50-50 chance for the player to voice emote on exit
		DwUtils.debug_sent.emit("/playvoice")

func _on_tab_switched(tab_scene_path: String) -> void:
	for _n in %Body.get_children():
		_n.queue_free()
	var _subpane_loader := AsyncControlLoader.new()
	_subpane_loader.source_scene = tab_scene_path
	_subpane_loader.target_scene = %Body
	call_deferred("add_child", _subpane_loader)
