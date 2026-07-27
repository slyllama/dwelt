@icon("res://generic/icons/UIPaneTab.svg")
@tool
extends TextureRect
# UIPaneTab
# Shouldn't change anything by itself - to be controlled by a UIPaneTabController

const TEXTURE_ACTIVE := preload("res://lib/ui/ui_pane/ui_pane_tab/textures/tab_active.png")
const TEXTURE_ACTIVE_HOVER := preload("res://lib/ui/ui_pane/ui_pane_tab/textures/tab_active_hover.png")
const TEXTURE_INACTIVE := preload("res://lib/ui/ui_pane/ui_pane_tab/textures/tab_inactive.png")
const TEXTURE_INACTIVE_HOVER := preload("res://lib/ui/ui_pane/ui_pane_tab/textures/tab_inactive_hover.png")

var active := false

@export var tab_text: String:
	set(_tab_text):
		tab_text = _tab_text
		$Label.text = tab_text
@export var tab_id: String
@export var tab_scene_path: String

func set_active(state := true) -> void:
	active = state
	if state:
		texture = TEXTURE_ACTIVE
		modulate.a = 1.0
	else:
		texture = TEXTURE_INACTIVE
		modulate.a = 0.65

# Handle hovering
func _on_mouse_entered() -> void:
	if active: texture = TEXTURE_ACTIVE_HOVER
	else: texture = TEXTURE_INACTIVE_HOVER

func _on_mouse_exited() -> void:
	if active: texture = TEXTURE_ACTIVE
	else: texture = TEXTURE_INACTIVE
