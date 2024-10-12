extends TextureButton
# DiamondButton
# Used for the map buttons

const TIME = 0.07
const TINT = Color(0.9, 0.9, 0.9)

func reset(conceal = false):
	$Highlight.clear()
	modulate = TINT
	if conceal:
		modulate.a = 0
		visible = false

func fade_in(highlight = false) -> void:
	visible = true
	
	var self_fade_tween = create_tween()
	self_fade_tween.tween_property(self, "modulate:a", 1.0, TIME)
	if highlight:
		$Highlight.visible = true
		$Highlight.flash()

func fade_out() -> void:
	var self_fade_tween = create_tween()
	self_fade_tween.tween_property(self, "modulate:a", 0.0, TIME)
	self_fade_tween.tween_callback(func():
		if visible: reset(true))

func _ready() -> void:
	reset()

func _on_mouse_entered() -> void:
	Global.hover_sound.emit()
	modulate = Color.WHITE
func _on_mouse_exited() -> void: modulate = TINT
func _on_focus_entered() -> void: Global.click_sound.emit()
