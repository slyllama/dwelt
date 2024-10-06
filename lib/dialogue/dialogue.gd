extends CanvasLayer
# Dialogue
# Plays simple, procedural dialogue passed to it in an array

signal line_finished_animating
signal dialogue_finished
var current_script: Array
var line_current = 0
var lines_total: int

@export var fade_width := 10
@export var chars_per_sec := 40

# Fade the text in using BBCode's built-in rendering features
func _set_fade(pos: int) -> void:
	$Text.text = ("[center][fade start=" + str(pos) + " length = " + str(fade_width) 
		+ "]" + current_script[line_current] + "[/fade][/center]")

func _animate_line() -> void:
	$Continue.visible = false
	var fade_tween = create_tween()
	var _l = current_script[line_current].length()
	fade_tween.tween_method(_set_fade, -10, _l, _l / float(chars_per_sec))
	fade_tween.tween_callback(line_finished_animating.emit)

func _continue() -> void:
	if line_current >= lines_total - 1:
		# Logic for clearing goes here
		dialogue_finished.emit()
		return
	line_current += 1
	_animate_line()

func play(script: Array):
	visible = true
	current_script = script
	lines_total = current_script.size()
	_animate_line() # animate first line

func _ready() -> void:
	# Establish correct visibility
	$Continue.visible = false
	visible = false

func _on_line_finished_animating() -> void:
	$Continue.visible = true
