shader_type spatial;
render_mode specular_disabled;

uniform sampler2D grass_base_texture: source_color;
uniform sampler2D grass_blend_texture: source_color;
uniform sampler2D cobble_texture: source_color;
uniform sampler2D blend_mask_texture;
uniform float uv_scale = 4.0;

void fragment() {
	float grass_blend_mask = texture(blend_mask_texture, UV).r;
	float blend_mask = texture(blend_mask_texture, UV * 1.5).r;
	
	// Grass
	vec3 grass_base = texture(grass_base_texture, UV * uv_scale).rgb;
	vec3 grass_blend = texture(grass_blend_texture, UV * uv_scale).rgb;
	vec3 grass = mix(grass_base, grass_blend, grass_blend_mask);
	
	// Cobble
	vec3 cobble = texture(cobble_texture, UV * uv_scale).rgb;
	ALBEDO = mix(grass, cobble, blend_mask);
}
