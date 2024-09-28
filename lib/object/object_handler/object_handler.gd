extends Node
# ObjectHandler
# Determines your proximal object - the one you're closest to

var proximal_object: Dictionary
var proximal_distance: float = 999
var objects: Array[DweltObject]

func _ready() -> void:
	# Get all of the objects in the parent (i.e. root) scene
	for o in Utilities.get_all_children(get_parent()):
		if o is DweltObject:
			objects.append(o)

var _f = false
func _physics_process(_delta: float) -> void:
	if !_f: # skip first frame
		_f = true
		return
	
	# Reset
	var in_range = false
	proximal_object = Global.PROXIMAL_OBJECT.duplicate()
	proximal_distance = 999
	
	# Find the nearest object in proximity and assign it globally
	for o: DweltObject in objects:
		# Find nearest object
		if o.in_range:
			in_range = true
			if o.distance_to_player < proximal_distance:
				proximal_distance = o.distance_to_player
				for param in Global.PROXIMAL_OBJECT:
					if param in proximal_object:
						proximal_object[param] = o[param]
	
	# Update the most proximal object and emit the appropriate signal
	if proximal_object.id != "none" and proximal_object.id != Global.proximal_object.id:
		Global.proximal_object = proximal_object
		Global.proximity_entered.emit()
	if proximal_object.id == "none" and Global.proximal_object.id != "none":
		Global.proximal_object = Global.PROXIMAL_OBJECT.duplicate()
		Global.proximity_left.emit()
