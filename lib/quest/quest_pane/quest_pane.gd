extends PanelContainer

func render(quest_data: Quest) -> void:
	if !quest_data:
		visible = false
		return
	visible = true
	%Title.text = quest_data.quest_name
	%Description.text = quest_data.description

func _ready() -> void:
	Save.quest_changed.connect(render)
