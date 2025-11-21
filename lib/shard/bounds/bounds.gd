extends Node3D

@export var size := 5.0:
	get: return(size)
	set(_val):
		size = _val
		for _n: Marker3D in get_children():
			var _b: StaticBody3D = _n.get_node("Boundary")
			_b.position.x = -size
