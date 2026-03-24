extends Node

const GRAVITY := -9.8

# References
var camera: Camera3D

func _init() -> void:
	AudioServer.set_bus_volume_linear(0, 0.0)
