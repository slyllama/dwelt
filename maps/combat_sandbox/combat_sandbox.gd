@tool
extends "res://lib/map/map.gd"

func _ready() -> void:
	super()

func _dwellan_portal_used() -> void:
	get_tree().change_scene_to_file(
		"res://maps/dwellan_island/dwellan_island.tscn")
