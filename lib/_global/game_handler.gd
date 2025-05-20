extends Node

signal life_lost

var max_lives = 5
var lives = max_lives

func lose_life() -> void:
	if lives > 0:
		lives -= 1
		life_lost.emit()
