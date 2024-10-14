extends Node2D
# Highlight
# Plays a flashing/shining animation, drawing the player's attention to an
# area on the screen

func clear():
	modulate.a = 0

# Will dissolve away after animating if fade_after is true
func flash(fade_after = false):
	$FlashAnim.play("flash")
	if fade_after:
		await $FlashAnim.animation_finished
		var fade_tween = create_tween()
		fade_tween.tween_property(self, "modulate:a", 0.0, 0.2)

func _ready() -> void:
	clear()
