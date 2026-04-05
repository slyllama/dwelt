@tool
class_name SettingsSlider extends HBoxContainer

@export var setting_id: String
@export var title: String

@onready var title_label := Label.new()
@onready var slider := HSlider.new()
@onready var right_padding := ColorRect.new()

# Update UI elements based on settings without applying the settings themselves
func redraw() -> void:
	var _value: String = Settings.settings[setting_id]
	slider.value = float(_value)

func _ready() -> void:
	if !setting_id:
		queue_free()
		return
	
	# Text visual setup
	add_theme_constant_override("separation", 7)
	title_label.custom_minimum_size.x = 140.0
	title_label.autowrap_mode = TextServer.AUTOWRAP_OFF
	
	# Configure slider
	slider.tick_count = 11
	slider.ticks_position = Slider.TICK_POSITION_CENTER
	slider.max_value = 1.0
	slider.step = 0.02
	slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	# Right-most padding setup
	right_padding.color = Color(0.0, 0.0, 0.0, 0.0)
	right_padding.custom_minimum_size.x = 1.0
	
	# Add children
	add_child(title_label)
	add_child(slider)
	add_child(right_padding)
	title_label.text = title
	
	if Engine.is_editor_hint(): return
	
	slider.drag_ended.connect(func(_value_changed: bool) -> void:
		Settings.apply_setting(setting_id, str(snapped(slider.value, 0.1))))
	
	# Redraw settings if they are reset or a redraw is requested
	Settings.settings_redraw.connect(redraw)
	
	if setting_id in Settings.settings:
		redraw()
	else: queue_free()
