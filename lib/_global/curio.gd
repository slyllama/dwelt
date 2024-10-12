extends Node
# Curio
# Contains the data that relates objects with curios and stores curio
# descriptions and lore, as well as the signals and parameters which bind
# everything together.

const TEXTURE_PATH = "res://lib/thingistry/curio_button/textures/"

signal collected(id)
signal curio_selected(id)
signal panel_opened

# Returns a ratio between the total number of objects associated with a curio and
# the amount of those objects collected by the player
func get_progress(id: String) -> float:
	if "objects" in DATA[id]:
		var _objects = DATA[id].objects
		var _object_count = _objects.size()
		var _collected_object_count = 0
		for _o in collected_objects: # compare collected objects with associated
			if _o in _objects:
				_collected_object_count += 1
		if _collected_object_count > 0:
			return(float(_collected_object_count) / float(_object_count))
		else: return(0)
	else:
		return(0)

func get_is_newly_collected(id: String) -> bool:
	if "objects" in DATA[id]:
		var _objects = DATA[id].objects
		for _o in collected_since_last_open:
			if _o in _objects:
				return(true)
	return(false)

const DATA = {
	"test_curio": {
		"name": "Test Curio",
		"objects": [
			"faceless_books",
			"aoibhe_painting"
		]
	},
	"foo": {
		"name": "Foo",
		"objects": [
			"test",
			"apples",
			"bananas",
			"cucumber"
		]
	},
	"bar": { "name": "Bar" },
	"bar2": { "name": "Bar" },
	"bar3": { "name": "Bar" },
	"bar4": { "name": "Bar" },
	"bar5": { "name": "Bar" },
	"bar6": { "name": "Bar" }
}

var collected_objects = [
	"faceless_books"
]

var collected_since_last_open = [] # used to highlight newly-collected curios
