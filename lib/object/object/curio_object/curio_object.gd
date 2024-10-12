class_name CurioDweltObject extends DweltObject
# CurioDweltObject
# An extension of the regular object which handles curio collecting

signal interacted_with_collected # this will only call if the curio has been collected
var collected = false

func collect() -> void:
	collected = true
	Curio.collected_objects.append(id) # add to saved collected objects
	Curio.collected_since_last_open.append(id) # add to objects collected since last panel open
	Curio.collected.emit(id)
	set_use_hold_circle(false)

func _ready() -> void:
	super()
	can_interact = true
	set_use_hold_circle(true)

func _on_interacted() -> void:
	if !collected: collect()
	# Always happens afterward
	interacted_with_collected.emit()
