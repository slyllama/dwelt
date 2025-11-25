@tool
class_name UIPane extends Panel

@export var title_text := "(Title)":
	get: return(title_text)
	set(_val):
		title_text = _val
		$Box/Title.text = title_text

func close() -> void:
	Global.ui_closed.emit()
	
	var _t = create_tween()
	_t.tween_property(self, "modulate:a", 0.0, 0.1)
	_t.tween_callback(queue_free)

func _init() -> void:
	if Engine.is_editor_hint(): return
	modulate.a = 0.0

func _ready() -> void:
	if Engine.is_editor_hint(): return
	
	await get_tree().process_frame
	var _t = create_tween()
	_t.tween_property(self, "modulate:a", 1.0, 0.1)
	$PaperSound.play()
	Utils.pdebug("Opening pane with title '" + title_text + "'.", "UIPane")
	
	for _n in $Box.get_children():
		if _n is Button:
			_n.mouse_entered.connect($HoverSound.play)
