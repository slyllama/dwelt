extends CanvasLayer

const QuitConfirmPane = preload("res://lib/ui/quit_confirm/quit_confirm.tscn")

func _fade_in() -> void:
	var _t = create_tween()
	_t.tween_property($FadeIn, "modulate:a", 0.0, 1.0)
	_t.tween_callback(func(): $FadeIn.visible = false)

func _close_ui() -> void:
	if $UILayer.get_child_count() > 0:
		for _n: UIPane in $UILayer.get_children():
			_n.close()
	pass

func _ready() -> void:
	Global.input_captured.connect(_close_ui)
	
	$FadeIn.visible = true
	$Debug.queue_free()
	await get_tree().create_timer(0.25).timeout
	_fade_in()

func _menu_button_pressed(id: String) -> void:
	_close_ui()
	
	match id:
		"quit":
			var _q = QuitConfirmPane.instantiate()
			$UILayer.add_child(_q)
		_: pass
