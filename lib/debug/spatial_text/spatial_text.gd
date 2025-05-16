@tool
extends VisibleOnScreenNotifier3D
# SpatialText
# Show some text on-screen in the 3D world

@export var text = "((Text))":
	get: return(text)
	set(_val):
		text = _val
		$FG/Text.text = "[center]" + text + "[/center]"

func _process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	var _screen_pos = Reporter.camera.unproject_position(position)
	var _in_window = (_screen_pos.x > 10.0 and _screen_pos.x < get_window().size.x - 10.0
		and _screen_pos.y > 10.0 and _screen_pos.y < get_window().size.y - 10.0)
	
	if _in_window and is_on_screen():
		if !$FG/Text.visible:
			$FG/Text.visible = true
	else:
		if $FG/Text.visible:
			$FG/Text.visible = false
	
	$FG/Text.position = Reporter.camera.unproject_position(position)
	$FG/Text.position.x -= $FG/Text.size.x / 2.0
