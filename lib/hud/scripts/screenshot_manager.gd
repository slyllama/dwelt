extends Node

const PATH := "user://screenshots/"
@onready var global_path :=ProjectSettings.globalize_path(PATH)

func take_screenshot() -> void:
	$Shutter.play()
	if !DirAccess.dir_exists_absolute(PATH):
		DirAccess.make_dir_absolute(PATH)
	
	var current_time := Time.get_datetime_string_from_system()
	var image_name := current_time.replace("T", " ").replace(":", "-")
	var image_path := PATH + image_name + ".png"
	var screenshot := get_viewport().get_texture().get_image()
	screenshot.save_png(image_path)
	screenshot = null

func open_folder() -> void:
	OS.shell_show_in_file_manager(global_path)
