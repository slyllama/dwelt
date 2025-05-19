extends Node
# Reporter
# The Reporter only "links through" to other parameters so they can be referenced
# Changing these parameters will not change anything in the game

# A "do" signal can be propogated from anywhere; it is a cause, not an effect
signal do_shake_camera

signal gadget_changed

# References to objects
var camera: Camera3D
var player: DweltPlayer

var current_gadget = null
var mouse_in_ui = false
var orbiting = false
var player_position = Vector3.ZERO
var projectile_count = 0
