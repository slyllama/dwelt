shader_type canvas_item;
#include "res://generic/materials/shaders/shader_utils.gdshaderinc"

uniform sampler2D swirl_texture: hint_default_black, repeat_enable;
uniform float exp: hint_range(0.1, 10.0) = 1.0;
uniform float alpha: hint_range(0.0, 1.0) = 1.0;

void fragment() {
	vec2 swirl_uv = SCREEN_UV + TIME * 0.05;
	swirl_uv += texture(swirl_texture, SCREEN_UV * 0.5).rg * 0.1;
	COLOR.a *= pow(texture(swirl_texture, swirl_uv).r, exp);
	COLOR.a *= ease_out_strong(alpha);
}
