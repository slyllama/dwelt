@tool
class_name Option extends HBoxContainer

@export var title := "(Title)":
	get: return(title)
	set(_val):
		title = _val
		$Title.text = _val

@export var id := "id"

@export var options: Array[OptionAlias] = []

# The current option is not necessarily the applied one - if this is changed,
# then the new setting will be applied on save
@onready var current_option: OptionAlias

func refresh() -> void:
	SettingsHandler.queued_changes[id] = current_option.id
	$Value.text = current_option.title

func _ready() -> void:
	if Engine.is_editor_hint(): return # live only
	if id in SettingsHandler.settings:
		for _o: OptionAlias in options:
			if _o.id == SettingsHandler.settings[id]:
				current_option = _o
				refresh()
	else:
		if options.size() > 0: # apply first option, for now
			current_option = options[0]
			refresh()

func _on_left_pressed() -> void:
	var _idx = options.find(current_option)
	if _idx == 0: current_option = options[options.size() - 1]
	else: current_option = options[_idx - 1]
	refresh()

func _on_right_pressed() -> void:
	var _idx = options.find(current_option)
	if _idx == options.size() - 1: current_option = options[0]
	else: current_option = options[_idx + 1]
	refresh()
