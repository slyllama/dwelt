shader_type spatial;
render_mode unshaded, blend_mix, shadows_disabled, fog_disabled;
#include "res://generic/materials/shaders/shader_utils.gdshaderinc"

uniform sampler2D rune_image: source_color, filter_linear_mipmap, hint_default_transparent;
uniform sampler2D wobble_noise: hint_default_black, repeat_enable;
uniform sampler2D screen_texture: hint_screen_texture;
uniform float circle_position = 0.5;
uniform float alpha = 1.0;

void fragment() {
	vec2 wobble_distortion = texture(wobble_noise, UV + TIME * 0.07).rg * 0.01;
	vec2 rune_uv = UV + wobble_distortion;
	vec3 rune_texture = texture(rune_image, rune_uv).rgb;
	
	ALBEDO = ripple(circle_position, alpha, UV + wobble_distortion, screen_texture, SCREEN_UV);
	ALBEDO += rune_texture.rgb;
	ALBEDO.r += texture(rune_image, rune_uv + vec2(0.002, 0)).r * 0.5;
	ALBEDO.g += texture(rune_image, rune_uv + vec2(0, 0.002)).r * 0.5;
}
