shader_type spatial;
render_mode unshaded, shadows_disabled, ambient_light_disabled, fog_disabled, cull_disabled;
#include "res://generic/materials/shaders/utils.gdshaderinc"

uniform sampler2D swirl_texture: filter_linear_mipmap, repeat_enable;
uniform sampler2D wobble_texture: filter_linear_mipmap, repeat_enable;
uniform float wobble_strength: hint_range(0.0, 1.0) = 0.6;
uniform float wobble_speed: hint_range(0.0, 2.0) = 0.1;
uniform sampler2D swirl_mask: filter_linear;

void fragment() {
	vec2 w_uv = texture(wobble_texture, UV * 0.5 + TIME * wobble_speed).rg;
	float swirl = texture(swirl_texture, UV + w_uv * wobble_strength).r;
	swirl = 1.0 - swirl;
	
	ALBEDO = vec3(1.0);
	ALPHA = pow(swirl, 1.0);
	ALPHA *= texture(swirl_mask, UV - vec2(1.01)).r;
}
