extends TextureButton
# DiamondButton
# Used for the map buttons

const TIME = 0.07
const TINT = Color(0.9, 0.9, 0.9)

func _reset(conceal = false):
	$Blur.modulate.a = 0
	$Blur.visible = false
	modulate = TINT
	if conceal:
		modulate.a = 0
		visible = false

func fade_in(highlight = false) -> void:
	$Blur.visible = true
	visible = true
	
	var self_fade_tween = create_tween()
	self_fade_tween.tween_property(self, "modulate:a", 1.0, TIME)
	if highlight:
		self_fade_tween.tween_callback(func():
			var fade_tween = create_tween()
			fade_tween.tween_property($Blur, "modulate:a", 1.0, TIME * 1.5))

func fade_out() -> void:
	var self_fade_tween = create_tween()
	self_fade_tween.tween_property(self, "modulate:a", 0.0, TIME)
	self_fade_tween.tween_callback(func():
		if visible: _reset(true))

func _ready() -> void:
	_reset()

func _on_mouse_entered() -> void:
	Global.hover_sound.emit()
	modulate = Color.WHITE
func _on_mouse_exited() -> void: modulate = TINT
func _on_focus_entered() -> void: Global.click_sound.emit()
