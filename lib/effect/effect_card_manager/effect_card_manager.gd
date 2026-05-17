extends HBoxContainer

var EffectCardScene := load("res://lib/effect/effect_card/effect_card.tscn")
var controller_focus_effect: EffectCard

@onready var controller_focus_cursor := Sprite2D.new()

@export var effect_manager: EffectManager:
	get: return(effect_manager)
	set(_effect_manager):
		deregister_effect_manager()
		effect_manager = _effect_manager
		on_effect_manager_change()

func deregister_effect_manager() -> void:
	if effect_manager:
		if effect_manager.effect_added.is_connected(on_effect_added):
			effect_manager.effect_added.disconnect(on_effect_added)

func on_effect_added(id: String) -> void:
	var effect := effect_manager.active_effects[id]
	var card: VBoxContainer = EffectCardScene.instantiate()
	card.effect_instance = effect
	add_child(card)

func on_effect_manager_change() -> void:
	# The effect manager has been cleared, and so all children need to be removed
	controller_focus_effect = null
	for _n: Node in get_children():
		_n.queue_free()
	
	if !effect_manager: return
	for _e: String in effect_manager.active_effects:
		var effect := effect_manager.active_effects[_e]
		if effect.visible_to_player:
			var card: VBoxContainer = EffectCardScene.instantiate()
			card.effect_instance = effect
			add_child(card)
	
	# Otherwise there is a new effect manager, and its signals need to be connected
	effect_manager.effect_added.connect(on_effect_added)

#region Controller focus methods
func give_controller_focus() -> void:
	for _n: Node in get_children():
		if _n is EffectCard:
			controller_focus_effect = _n
			DweltInput.focused_effect_changed.emit(controller_focus_effect)
			break

func release_controller_focus() -> void:
	controller_focus_effect = null
	DweltInput.focused_effect_changed.emit(controller_focus_effect)

func controller_focus_next() -> void:
	if controller_focus_effect in get_children():
		var _ind := controller_focus_effect.get_index()
		if _ind < get_child_count() - 1:
			controller_focus_effect = get_child(_ind + 1)
			DweltInput.focused_effect_changed.emit(controller_focus_effect)

func controller_focus_previous() -> void:
	if controller_focus_effect in get_children():
		var _ind := controller_focus_effect.get_index()
		if _ind > 0:
			controller_focus_effect = get_child(_ind - 1)
			DweltInput.focused_effect_changed.emit(controller_focus_effect)
#endregion

func _ready() -> void:
	for _n: Node in get_children(): _n.queue_free()
	
	# Add the cursor to the scene
	controller_focus_cursor.texture = load("res://lib/effect/effect_card_manager/textures/effect_cursor.png")
	add_child(controller_focus_cursor, false, Node.INTERNAL_MODE_FRONT)
	controller_focus_cursor.scale = Vector2(0.6, 0.6)
	controller_focus_cursor.visible = false

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("inspect_effects"):
		release_controller_focus()
	
	if Input.is_action_pressed("inspect_effects") and controller_focus_effect:
		if Input.is_action_just_pressed("ui_right"):
			controller_focus_next()
		elif Input.is_action_just_pressed("ui_left"):
			controller_focus_previous()

func _process(_delta: float) -> void:
	if controller_focus_effect:
		controller_focus_cursor.visible = true
		controller_focus_cursor.global_position = controller_focus_effect.global_position + controller_focus_effect.size / 2.0 + Vector2(0, 10.0)
	else: controller_focus_cursor.visible = false
