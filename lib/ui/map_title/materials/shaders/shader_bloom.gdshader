shader_type canvas_item;
#include "res://generic/materials/shaders/shader_utils.gdshaderinc"

uniform sampler2D swirl_texture: hint_default_black, repeat_enable;
uniform float size: hint_range(0.0, 1.0);

float ease_out_strong(float x) { // based on a quintic easing, but stronger
	return (1.0 - pow(1.0 - x, 7));
}

void fragment() {
	float swirl = vec3(texture(swirl_texture, UV * vec2(3.0, 1.5)).r).r;
	float mask = vec3(circle(UV - vec2(0.5), size, size * 3.0 + 0.1)).r;
	COLOR.rgb = vec3(1.0);
	COLOR.a = (1.0 - mask / swirl) * ease_out_strong(size);
}
