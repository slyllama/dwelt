extends TextureButton

func _on_pressed() -> void:
	if $WebCD.is_stopped():
		$WebCD.start()
		OS.shell_open("https://slyllama.net")
