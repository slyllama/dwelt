shader_type spatial;
render_mode specular_disabled;

// Grasses
uniform sampler2D blend_mask_texture: hint_default_black; 
uniform sampler2D a_texture: source_color, hint_default_white;
uniform sampler2D b_texture: source_color;
uniform float a_uv_scale = 1.0;
uniform float b_uv_scale = 1.0;
uniform vec3 a_albedo: source_color = vec3(1.0);
uniform vec3 b_albedo: source_color = vec3(1.0);

// Stone
uniform sampler2D stone_mask_texture: hint_default_black;
uniform sampler2D stone_texture: source_color, hint_default_white;
uniform float stone_uv_scale = 1.0;
uniform vec3 stone_albedo: source_color = vec3(1.0);

void fragment() {
	// Add colour
	vec3 a = texture(a_texture, UV * a_uv_scale).rgb * a_albedo;
	vec3 b = texture(b_texture, UV * b_uv_scale).rgb * b_albedo;
	ALBEDO = mix(a, b, texture(blend_mask_texture, UV).r);
	
	// Add stone
	float stone_mask = texture(stone_mask_texture, UV).r;
	vec3 stone = texture(stone_texture, UV * stone_uv_scale).rgb * stone_albedo;
	ALBEDO = mix(ALBEDO, stone, stone_mask);
}
