extends Node2D
# Highlight
# Plays a flashing/shining animation, drawing the player's attention to an
# area on the screen

func clear():
	modulate.a = 0

func flash():
	$FlashAnim.play("flash")

func _ready() -> void:
	clear()
