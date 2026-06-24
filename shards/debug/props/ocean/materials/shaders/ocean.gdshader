shader_type spatial;
#include "res://generic/materials/shaders/utils.gdshaderinc"

uniform float roughness = 0.2;
uniform float speed_scale = 1.0;
uniform float normal_strength: hint_range(0.0, 10.0) = 1.0;
uniform float foam_exponent = 3.0;
uniform float metallic = 1.0;
uniform float alpha_mottle_intensity: hint_range(0.0, 1.0) = 0.2;
uniform vec2 uv_scale = vec2(12.0);

uniform vec3 primary_color: source_color;
uniform vec3 foam_color: source_color;

uniform sampler2D normal_a: hint_normal;
uniform sampler2D normal_b: hint_normal;
uniform sampler2D light_foam: filter_linear_mipmap, repeat_enable;
uniform sampler2D alpha_mask: hint_default_black;

void fragment() {
	NORMAL_MAP = mix(
		texture(normal_a, UV * vec2(uv_scale) + TIME * 0.02 * speed_scale).rgb,
		texture(normal_b, UV * vec2(uv_scale * 0.75) - TIME * 0.017 * speed_scale).rgb,
		0.5);
	NORMAL_MAP_DEPTH = normal_strength;

	ALPHA -= texture(alpha_mask, UV).r;
	ALPHA -= (1.0 - texture(light_foam, UV * uv_scale).r) * alpha_mottle_intensity;
	ALPHA = clamp(ALPHA, 0.0, 1.0);

	float foam_mix = pow(texture(light_foam, UV * uv_scale + TIME * -0.02 * speed_scale).r, foam_exponent);
	foam_mix *= fresnel(2.0, NORMAL, VIEW);

	ALBEDO = primary_color;
	ALBEDO = mix(ALBEDO, foam_color, foam_mix);
	ALBEDO += pow(texture(alpha_mask, UV).g, 0.9) * foam_color * 0.5;
	ALBEDO = clamp(ALBEDO, vec3(0.0), vec3(1.0));

	ROUGHNESS = roughness;
	METALLIC = metallic;
}
