shader_type spatial;
render_mode specular_disabled;

uniform sampler2D grass_base_texture: source_color;
uniform sampler2D grass_blend_texture: source_color;
uniform sampler2D cobble_texture: source_color;
uniform sampler2D blend_mask_texture;
uniform vec3 tint: source_color = vec3(1.0);
uniform float uv_scale = 4.0;

uniform sampler2D dirt_mask_texture: hint_default_black;
uniform sampler2D dirt_texture;
uniform vec3 dirt_tint: source_color = vec3(1.0);
uniform float dirt_intensity: hint_range(0.0, 1.0) = 1.0;
uniform float dirt_uv_scale;

void fragment() {
	float grass_blend_mask = texture(blend_mask_texture, UV * 4.0).r;
	float blend_mask = texture(blend_mask_texture, UV * 2.0 + vec2(0.25, 0.0)).r;
	
	// Grass
	vec3 grass_base = texture(grass_base_texture, UV * uv_scale).rgb;
	vec3 grass_blend = texture(grass_blend_texture, UV * uv_scale).rgb;
	vec3 grass = mix(grass_base, grass_blend, grass_blend_mask);
	
	// Cobble
	vec3 cobble = texture(cobble_texture, UV * uv_scale).rgb;
	ALBEDO = mix(grass, cobble, pow(blend_mask, 2.0) * 0.6);
	ALBEDO *= tint;
	
	// Dirt
	vec3 dirt = texture(dirt_texture, UV * dirt_uv_scale).rgb;
	float dirt_mask = texture(dirt_mask_texture, UV).r;
	ALBEDO = mix(ALBEDO, dirt * dirt_tint, dirt_mask * dirt_intensity);
}
