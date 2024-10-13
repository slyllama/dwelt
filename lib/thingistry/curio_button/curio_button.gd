class_name CurioButton extends VBoxContainer
const TEXTURE_UNKNOWN = preload("res://lib/thingistry/curio_button/textures/uncollected.png")
const TEXTURE_EMPTY = preload("res://lib/thingistry/curio_button/textures/empty.png")

@export var curio_id: String = "none" # default to none to make an empty, non-interactable button

# Send the global position of this button up the chain when hovered
# This allows Thingistry to move its cursor to it
signal clicked_button(global_position)
var newly_collected = false

func get_center() -> Vector2:
	return($Button.global_position + $Button.size / 2) # center global position

func _ready() -> void:
	$Button/DebugDetails.text = curio_id
	$Button/DebugDetails.visible = Global.debug_visible
	Global.debug_visible_toggled.connect(func():
		$Button/DebugDetails.visible = Global.debug_visible)
	
	if !curio_id == "none":
		$Button/Progress.value = Curio.get_progress(curio_id) * 100
		if Curio.get_progress(curio_id) == 0:
			$Button.texture_normal = TEXTURE_UNKNOWN
		else:
			var texture_path = Curio.TEXTURE_PATH + curio_id + ".png"
			if ResourceLoader.exists(texture_path):
				$Button/ItemTexture.texture = load(texture_path)
		
		if Curio.get_is_newly_collected(curio_id):
			$Button/Notification.visible = true
			newly_collected = true
	else: # buttons with a "none" id will just render as empty squares in the grid
		$Button/Progress.visible = false
		$Button.texture_normal = TEXTURE_EMPTY

func _on_button_down() -> void:
	if curio_id == "none": return
	if $Button/Notification.visible: # dismiss 'newly collected' notification
		$Button/Notification.visible = false
	
	clicked_button.emit(get_center())
	Global.hover_sound.emit()
	Curio.curio_selected.emit(curio_id)
