extends Node
# Curio
# Contains the data that relates objects with curios and stores curio
# descriptions and lore, as well as the signals and parameters which bind
# everything together.

signal curio_hovered(id)

const DATA = {
	"none": {
		"name": " "
	},
	"test_curio": {
		"name": "Test Curio"
	},
	"foo": {
		"name": "Foo"
	},
	"bar": {
		"name": "Bar"
	}
}
