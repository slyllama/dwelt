extends HBoxContainer

func _ready() -> void:
	$Menu.get_popup().id_pressed.connect(func(id):
		$Menu.text = $Menu.get_popup().get_item_text(id))
