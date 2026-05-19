extends CanvasLayer

func update_sv_size() -> void:
	var _size := get_window().size / get_window().content_scale_factor
	%HSWorldViewport.size = _size

func _ready() -> void:
	get_window().size_changed.connect(update_sv_size)
	update_sv_size()
	
	await get_tree().process_frame
	%Animation.play("fade_in")
