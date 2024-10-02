extends HBoxContainer
# SettingsDropdown
# Multi-choice options in the settings menu!

@export var title = "Setting"
@export var id: String
@export var options: Array[String]
@export var default_option = ""
@onready var selected_option = default_option

# Update displayed value
func _refresh() -> void:
	$Menu.text = str(selected_option).capitalize()

func _ready() -> void:
	$Title.text = title + ":"
	
	# Populate based on exported variables and refresh
	for option in options:
		$Menu.get_popup().add_item(str(option).capitalize())
	for m in Utilities.get_all_children($Menu.get_popup(), true):
		if "mouse_filter" in m: m.mouse_filter = MOUSE_FILTER_PASS
	_refresh()
	
	# Update settings (and display) when an option is selected from the list
	$Menu.get_popup().id_pressed.connect(func(n):
		selected_option = options[n]
		SettingsHandler.update(id, selected_option)
		Global.popup_open = false
		_refresh())

	# Update when a setting is changed/established (correctly populates the field
	# when the game is started, for instance)
	SettingsHandler.setting_changed.connect(func(parameter):
		if id == parameter:
			selected_option = SettingsHandler.settings[parameter]
			_refresh())

func _on_menu_about_to_popup() -> void:
	Global.popup_open = true
