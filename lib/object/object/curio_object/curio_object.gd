@tool
class_name CurioDweltObject extends DweltObject
# CurioDweltObject
# An extension of the regular object which handles curio collecting

## If this is [code]false[/code], the thingistry will wait for a
## [code]Global.interaction_ended[/code] event before opening. Otherwise the
## thingistry will open at the same time as the interaction is played.
@export var simultaneous_curio = false

signal interacted_with_collected # this will only call if the curio has been collected
var collected = false

func collect() -> void:
	collected = true
	Curio.collected_objects.append(id) # add to saved collected objects
	Curio.last_collected = id
	Curio.collected.emit(id)
	set_use_hold_circle(false)
	
	if simultaneous_curio:
		Global.interaction_ended.emit()

func _ready() -> void:
	if Engine.is_editor_hint(): return
	
	super()
	can_interact = true
	set_use_hold_circle(true)

func _on_interacted() -> void:
	if !collected: collect()
	interacted_with_collected.emit()
