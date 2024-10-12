class_name CurioButton extends VBoxContainer
const TEXTURE_UNKNOWN = preload("res://lib/thingistry/curio_button/textures/uncollected.png")
@export var curio_id: String

# Send the global position of this button up the chain when hovered
# This allows Thingistry to move its cursor to it
signal clicked_button(global_position)

func get_center() -> Vector2:
	return($Button.global_position + $Button.size / 2) # center global position

func _ready() -> void:
	$Progress.value = Curio.get_progress(curio_id) * 100
	if Curio.get_progress(curio_id) == 0:
		$Button.texture_normal = TEXTURE_UNKNOWN
	else:
		var texture_path = Curio.TEXTURE_PATH + "curio_" + curio_id + ".png"
		if ResourceLoader.exists(texture_path):
			$Button/ItemTexture.texture = load(texture_path)
	
	if Curio.get_is_newly_collected(curio_id):
		$Button/Notification.visible = true

func _on_button_down() -> void:
	if $Button/Notification.visible: # dismiss 'newly collected' notification
		$Button/Notification.visible = false
	
	clicked_button.emit(get_center())
	Global.hover_sound.emit()
	Curio.curio_selected.emit(curio_id)
