@tool
class_name SettingsSelector extends HBoxContainer
# Settings select from multiple options

@export var setting_id: String
@export var options: Array[String] = []
@export var title: String

@onready var arrow_texture := load("res://lib/settings/settings_ui_element/textures/arrow.png")
@onready var title_label := Label.new()
@onready var left_button := TextureButton.new()
@onready var value_label := Label.new()
@onready var right_button := TextureButton.new()

func redraw() -> void:
	value_label.text = Settings.settings[setting_id].capitalize()

func _ready() -> void:
	if !setting_id:
		queue_free()
		return
	
	# Text visual setup
	add_theme_constant_override("separation", 7)
	title_label.custom_minimum_size.x = 140.0
	title_label.autowrap_mode = TextServer.AUTOWRAP_OFF
	value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	value_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	value_label.add_theme_color_override("font_color", Color(0.9, 0.78, 0.56, 1.0))
	
	# Button visual setup
	left_button.texture_normal = arrow_texture
	left_button.ignore_texture_size = true
	left_button.stretch_mode = TextureButton.STRETCH_SCALE
	left_button.custom_minimum_size = Vector2(12.0, 24.0)
	right_button.texture_normal = arrow_texture
	right_button.flip_h = true
	right_button.ignore_texture_size = true
	right_button.stretch_mode = TextureButton.STRETCH_SCALE
	right_button.custom_minimum_size = Vector2(12.0, 24.0)
	
	# Add children
	add_child(title_label)
	add_child(left_button)
	add_child(value_label)
	add_child(right_button)
	title_label.text = title
	
	if Engine.is_editor_hint(): return
	
	# Redraw settings if they are reset or a redraw is requested
	Settings.settings_redraw.connect(redraw)
	
	if !setting_id in Settings.settings:
		queue_free()
		return
	
	# Connect buttons
	left_button.pressed.connect(func() -> void:
		var _current_value := value_label.text.to_lower()
		var _idx := options.find(_current_value)
		var _value: String
		if _idx > 0:
			_value = options[_idx - 1]
		else:
			_value = options[options.size() - 1]
		value_label.text = _value.capitalize()
		Settings.apply_setting(setting_id, _value))
	
	right_button.pressed.connect(func() -> void:
		var _current_value := value_label.text.to_lower()
		var _idx := options.find(_current_value)
		var _value: String
		if _idx < options.size() - 1:
			_value = options[_idx + 1]
		else:
			_value = options[0]
		value_label.text = _value.capitalize()
		Settings.apply_setting(setting_id, _value))
	
	# Get from settings
	redraw()
