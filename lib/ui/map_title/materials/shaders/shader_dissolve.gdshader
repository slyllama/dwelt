shader_type canvas_item;
#include "res://generic/materials/shaders/shader_utils.gdshaderinc"

uniform sampler2D swirl_texture: hint_default_black, repeat_enable;
uniform float exp: hint_range(0.1, 10.0) = 1.0;

void fragment() {
	COLOR.a *= pow(texture(swirl_texture, SCREEN_UV * 3.0 + TIME * 0.05).r, exp);
}
