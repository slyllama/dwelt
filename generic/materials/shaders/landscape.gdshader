shader_type spatial;
render_mode specular_disabled;

uniform sampler2D grass_mask: source_color;
uniform sampler2D grass_1_texture: source_color;
uniform sampler2D grass_2_texture: source_color;
uniform vec3 grass_1_albedo: source_color = vec3(1.0);
uniform vec3 grass_2_albedo: source_color = vec3(1.0);
uniform float grass_1_uv_scale = 1.0;
uniform float grass_2_uv_scale = 1.0;

uniform sampler2D roots_mask: source_color;
uniform sampler2D roots_texture: source_color;
uniform float roots_uv_scale = 1.0;

void fragment() {
	vec3 g1 = texture(grass_1_texture, UV * grass_1_uv_scale).rgb * grass_1_albedo;
	vec3 g2 = texture(grass_2_texture, UV * grass_2_uv_scale).rgb * grass_2_albedo;
	ALBEDO = mix(g1, g2, texture(grass_mask, UV).r);
	
	vec3 r = texture(roots_texture, UV * roots_uv_scale).rgb;
	ALBEDO = mix(ALBEDO, r, texture(roots_mask, UV).r);
}
