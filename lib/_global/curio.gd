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

# Get the total page count - useful for displaying pagination
func get_page_count(size: int) -> int:
	var _page_count = 0
	var _curio_count = DATA.size()
	while _curio_count > 0:
		_curio_count -= size
		_page_count += 1
	return(_page_count)

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
		"name": "Bat"
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
	"quacker": {
		"name": "Quacker",
		"short_desc": "WELL HELLO THERE",
		"objects": [
			"apples",
			"bananas",
			"cucumber"
		],
		"object_text": {
			"apples": "((This text gets added to the 'quacker' curio when the 'apples' object is picked up.))",
			"cucumber": "((What the actual fudge))"
		}
	}
}

var collected_objects = [
	"amber"
]

var collected_since_last_open = [] # used to highlight newly-collected curios
