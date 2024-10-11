class_name CurioButton extends VBoxContainer
const TEXTURE_UNKNOWN = preload("res://lib/thingistry/curio_button/textures/uncollected.png")
const TEXTURE_PATH = "res://lib/thingistry/curio_button/textures/"

@export var curio_id: String

# Send the global position of this button up the chain when hovered
# This allows Thingistry to move its cursor to it
signal mouse_entered_button(global_position)

func get_center() -> Vector2:
	return($Button.global_position + $Button.size / 2) # center global position

func _ready() -> void:
	$Progress.value = Curio.get_progress(curio_id) * 100
	if Curio.get_progress(curio_id) == 0:
		$Button.texture_normal = TEXTURE_UNKNOWN
	else:
		var texture_path = TEXTURE_PATH + "curio_" + curio_id + ".png"
		if ResourceLoader.exists(texture_path):
			$Button/ItemTexture.texture = load(texture_path)

func _on_mouse_entered() -> void:
	mouse_entered_button.emit(get_center())
	Global.hover_sound.emit()
	Curio.curio_selected.emit(curio_id)
