extends CanvasLayer

var active := false

func open(scene_path: String) -> void:
	if active: return # don't repeat
	
	for _n in %Content.get_children():
		_n.queue_free()
	if scene_path != "":
		var scene: Control = load(scene_path).instantiate()
		%Content.add_child(scene)
	
	active = true
	get_tree().paused = true
	visible = true
	$Anim.play("fade_in")

func close() -> void:
	if !active: return # don't repeat
	
	await get_tree().process_frame
	$Anim.play_backwards("fade_in")
	await $Anim.animation_finished
	active = false
	visible = false
	get_tree().paused = false
	
	for _n in %Content.get_children():
		_n.queue_free()

func _ready() -> void:
	Dwelt.captured_pane_open.connect(open)
	$DebugBG.visible = false

func _input(_event: InputEvent) -> void:
	if !visible: return
	if (Input.is_action_just_pressed("ui_cancel")
		and Dwelt.ui_pane_manager.panes.size() == 0):
		close()
