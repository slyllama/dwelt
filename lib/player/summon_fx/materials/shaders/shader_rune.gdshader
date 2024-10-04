shader_type spatial;
render_mode unshaded, blend_mix, shadows_disabled, fog_disabled;
#include "res://generic/materials/shaders/shader_utils.gdshaderinc"

uniform sampler2D rune_image: source_color, filter_linear_mipmap, hint_default_transparent;
uniform sampler2D wobble_noise: hint_default_black, repeat_enable;
uniform sampler2D screen_texture: hint_screen_texture;
uniform float circle_position = 0.5;
uniform float alpha = 1.0;
uniform float distortion_level = 0.01;

void fragment() {
	vec2 wobble_distortion = texture(wobble_noise, UV + TIME * 0.07).rg * distortion_level;
	vec2 rune_uv = UV + wobble_distortion;
	vec3 rune_texture = texture(rune_image, rune_uv).rgb;
	
	ALBEDO = ripple(circle_position, alpha, UV + wobble_distortion, screen_texture, SCREEN_UV);
	ALBEDO.g += rune_texture.g;
	ALBEDO.r += texture(rune_image, rune_uv + vec2(0.008, 0)).r * 0.2;
	ALBEDO.g += texture(rune_image, rune_uv + vec2(0, 0.008)).r * 0.2;
	ALPHA = alpha;
}
