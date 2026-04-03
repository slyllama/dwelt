class_name EffectInstance extends Resource

signal finished

enum Type {DURATION, QUANTITY}

@export var id := "blank_effect"
@export var title := "((Effect Title))"
@export_multiline() var description := "((Description))"
@export var icon := load("res://effects/icons/no_icon.jpg")
@export var type: Type

@export_category("Effect State")
@export var duration_stacks := false
@export var total_duration := 5.0 # seconds
@export var quantity_stacks := false
@export var hide_single_quantity := false
@export_range(0, 99, 1) var total_quantity := 3

# WARNING: these are set from the original value, not the exported value.
# They therefore must be set again when added in the EffectManager
var current_duration := total_duration
var current_quantity := total_quantity
