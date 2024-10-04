shader_type spatial;
render_mode unshaded, shadows_disabled, fog_disabled;
#include "res://generic/materials/shaders/shader_utils.gdshaderinc"

uniform sampler2D screen_texture: hint_screen_texture;
uniform float circle_position = 0.5;
uniform float alpha = 1.0;

void fragment() {
	ALBEDO = ripple(circle_position, alpha, UV, screen_texture, SCREEN_UV);
}
