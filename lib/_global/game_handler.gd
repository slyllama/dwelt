extends Node

var max_lives = 5
var lives = max_lives
var score = 0

func lose_life() -> void:
	if lives > 0:
		Reporter.do_shake_camera.emit()
		lives -= 1
	if lives == 0:
		pass # TODO: no lives left
