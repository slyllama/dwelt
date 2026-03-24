shader_type spatial;
render_mode specular_disabled, fog_disabled, ambient_light_disabled;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear;
uniform sampler2D hologram_mask_texture: source_color, filter_linear, repeat_enable;

uniform vec3 hologram_color: source_color = vec3(0.0, 1.0, 0.0);
uniform float hologram_uv_scale = 1.0;

void fragment() {
	vec3 screen = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
	
	// Hologram
	vec2 hologram_uv = SCREEN_UV * hologram_uv_scale + TIME * vec2(0.01, 0.01);
	float hologram_mask = texture(hologram_mask_texture, hologram_uv).r;
	
	ALBEDO = mix(screen, hologram_color, hologram_mask);
	EMISSION = ALBEDO * 2.0;
}
