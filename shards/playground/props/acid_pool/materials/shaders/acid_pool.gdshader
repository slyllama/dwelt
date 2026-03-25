shader_type spatial;
render_mode shadows_disabled;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
uniform sampler2D acid_texture: repeat_enable, source_color;
uniform sampler2D noise_texture: repeat_enable; // used for wobble
uniform sampler2D normal_texture: hint_normal, repeat_enable;

instance uniform float uv_scale = 1.0;

uniform float wobble_intensity = 0.03;
uniform float emission_intensity: hint_range (0.0, 1.0) = 0.25;
uniform float speed = 0.05;
uniform float normal_uv_relative_scale = 0.75;
uniform float underlay_pass_through: hint_range(0.0, 1.0) = 0.75;
uniform float normal_map_depth: hint_range(0.0, 2.0) = 1.0;
uniform float roughness: hint_range(0.0, 1.0) = 0.1;

void fragment() {
	// Wobble
	float wobble = texture(noise_texture, UV * uv_scale + TIME * speed * 4.0).r * -1.0;
	wobble *= wobble_intensity;
	
	// Diffuse textures
	vec3 underlay = texture(SCREEN_TEXTURE, SCREEN_UV + wobble * 0.2).rgb;
	vec3 acid = texture(acid_texture, UV * uv_scale + wobble + TIME * speed).rgb;
	
	// Compose
	ALBEDO = mix(acid, underlay, (1.0 - acid.r) * underlay_pass_through);
	ROUGHNESS = roughness;
	
	// Normals (waves)
	vec2 normal_uv = UV * uv_scale + wobble + TIME * speed * 1.2;
	normal_uv *= normal_uv_relative_scale;
	NORMAL_MAP = texture(normal_texture, normal_uv).rgb;
	NORMAL_MAP_DEPTH = normal_map_depth;
	
	// Emission
	EMISSION = ALBEDO * vec3(acid.g) * emission_intensity;
}
