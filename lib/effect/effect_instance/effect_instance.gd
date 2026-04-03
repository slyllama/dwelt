class_name EffectInstance extends Resource

signal finished

enum Type {DURATION, QUANTITY}

@export var id := "blank_effect"
@export var icon: Texture2D
@export var type: Type

@export_category("Effect State")
@export var duration_stacks := false
@export var total_duration := 5.0 # seconds
@export var quantity_stacks := false
@export_range(0, 99, 1) var total_quantity := 3

var current_duration := total_duration
var current_quantity := total_quantity
