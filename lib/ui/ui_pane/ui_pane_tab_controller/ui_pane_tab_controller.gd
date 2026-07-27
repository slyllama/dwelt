class_name UIPaneTabController extends HBoxContainer

@export var initial_active_tab_id := ""

signal tab_switched(tab_scene_path: String)

func _init() -> void:
	use_parent_material = true
	alignment = BoxContainer.ALIGNMENT_CENTER

func switch_tab(tab_id: String) -> void:
	for _n in get_children():
		if "tab_id" in _n:
			_n.set_active(false) # make all inactive first
	for _n in get_children():
		if "tab_id" in _n:
			if _n.tab_id == tab_id:
				_n.set_active()
				if "tab_scene_path" in _n:
					tab_switched.emit(_n.tab_scene_path)
				break

func _ready() -> void:
	switch_tab("gadgets")
	# Connect tab inputs
	for _n in get_children():
		if "tab_id" in _n:
			_n.gui_input.connect(func(_event: InputEvent) -> void:
				if Input.is_action_just_pressed("left_click"):
					switch_tab(_n.tab_id))
