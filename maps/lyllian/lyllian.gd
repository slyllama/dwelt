@tool
extends "res://lib/map/map.gd"

func _ready() -> void:
	super()
	
	if Engine.is_editor_hint(): return
	configure_map({
		"bg_color": Color(0.15, 0.15, 0.15)
	})

func _to_dwellan() -> void:
	Global.change_map("dwellan_island")
