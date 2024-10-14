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

const DATA = {
	"gratitude": {
		"name": "Gratitude",
		"short_desc": "You could be doing any number of cool and interesting things right now; but you're here, wandering through some guy's dream space-slash-environment art portfolio. And that guy is very, very grateful for your time and presence.\n\nThere's no real gameplay or through-line here, but there are a number of vistas and curiosities to seek out, some of which might resonate and remain with you.",
		"objects": [
			"gratitude_note"
		]
	},
	"erudite_mushrooms": {
		"name": "Erudite Mushrooms",
		"short_desc": "The mushrooms have absorbed almost all that these books contain, ink crumbling further into anonymity with each fungal inquiry. Particularly voracious readers, these caps are.",
		"objects": [
			"faceless_books"
		]
	},
	"aoibhe": {
		"name": "Aoibhe",
		"short_desc": "The very air seems to whisper the name 'Aoibhe', as if the walls know her better than any living soul.",
		"objects": [
			"aoibhe_painting"
		]
	}
}

var collected_objects = [
	"gratitude_note"
]

# Interacting with a curio will fill this value - it will be used to summon
# the thingistry with the correct curio once the interaction sequence has
# completed
var last_collected = ""
