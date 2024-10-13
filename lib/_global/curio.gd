extends Node
# Curio
# Contains the data that relates objects with curios and stores curio
# descriptions and lore, as well as the signals and parameters which bind
# everything together.

const TEXTURE_PATH = "res://lib/thingistry/curio_button/textures/items/"

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
	"ant": {
		"name": "Ant",
		"objects": [
			"amber",
			"blue"
		],
		"short_desc": "((This one actually has a short description!))"
	},
	"bat": {
		"name": "Bat",
		"objects": [
			"apples",
			"bananas",
			"cucumber"
		]
	},
	"cat": { "name": "Cat" },
	"dog": { "name": "Dog" },
	"eagle": { "name": "Eagle" },
	"fox": { "name": "Fox" },
	"gecko": { "name": "Gecko" },
	"horse": { "name": "Horse" },
	"iguana": { "name": "Iguana" },
	"jackelope": { "name": "Jackelope" },
	"kitten": { "name": "Kitten" },
	"lemur": { "name": "Lemur" },
	"monkey": { "name": "Monkey" },
	"nice_creature": { "name": "Nice Creature" },
	"orangutan": { "name": "Orangutan" },
	"parrot": { "name": "Parrot" },
	"quacker": { "name": "Quacker" },
}

var collected_objects = [
	"amber"
]

var collected_since_last_open = [] # used to highlight newly-collected curios
