class_name EffectBar extends HBoxContainer

var EffectCardScene := load("res://lib/effect/effect_card/effect_card.tscn")
var controller_focus_effect: EffectCard

@onready var controller_focus_cursor := Sprite2D.new()

@export var effect_manager: EffectManager:
	get: return(effect_manager)
	set(_effect_manager):
		deregister_effect_manager()
		effect_manager = _effect_manager
		on_effect_manager_change()

@export var reset_size_on_update := false

func deregister_effect_manager() -> void:
	if effect_manager:
		if effect_manager.effect_added.is_connected(on_effect_added):
			effect_manager.effect_added.disconnect(on_effect_added)

func on_effect_added(id: String) -> void:
	var effect := effect_manager.active_effects[id]
	var card: EffectCard = EffectCardScene.instantiate()
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
			var card: EffectCard = EffectCardScene.instantiate()
			card.effect_instance = effect
			add_child(card)
	
	# Otherwise there is a new effect manager, and its signals need to be connected
	effect_manager.effect_added.connect(on_effect_added)
	
	# Re-center (if selectedO
	if reset_size_on_update:
		await get_tree().process_frame
		size.x = 0.0
		position.x = -size.x / 2.0

func _ready() -> void:
	for _n: Node in get_children(): _n.queue_free()
