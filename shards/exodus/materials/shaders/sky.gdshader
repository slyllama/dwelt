shader_type sky;

// Stars
uniform sampler2D blend_mask_texture: hint_default_black; 
uniform sampler2D a_texture: source_color, hint_default_white;
uniform sampler2D b_texture: source_color;
uniform float a_uv_scale = 1.0;
uniform float b_uv_scale = 1.0;
uniform vec3 a_albedo: source_color = vec3(1.0);
uniform vec3 b_albedo: source_color = vec3(1.0);

// Red gradient (to merge with fog)
uniform sampler2D gradient_texture: source_color, hint_default_black;

// Shimmering red effect
uniform sampler2D shimmer_texture;
uniform vec3 shimmer_color: source_color;
uniform float shimmer_intensity: hint_range(0.0, 1.0) = 1.0;

// Watercolour overlay (colour dodge)
uniform sampler2D overlay_dodge_texture: hint_default_black;
uniform float overlay_uv_scale = 6.0;
uniform float overlay_intensity = 4.0;

vec3 colour_dodge(vec3 base, vec3 blend){ return base / (1.0 - blend); }

void sky() {
	// Add colour
	vec3 a = texture(a_texture, SKY_COORDS * a_uv_scale).rgb * a_albedo;
	vec3 b = texture(b_texture, SKY_COORDS * b_uv_scale).rgb * b_albedo;
	COLOR = mix(a, b, texture(blend_mask_texture, SKY_COORDS).r);
	
	// Apply gradient
	vec4 gradient = texture(gradient_texture, SKY_COORDS).rgba;
	COLOR = mix(COLOR, gradient.rgb, gradient.a);
	
	// Apply shimmer
	float shimmer = 1.0 - texture(
		shimmer_texture, SKY_COORDS + vec2(0.025, 0.005) * TIME).r;
	COLOR = mix(COLOR, shimmer_color, shimmer * shimmer_intensity);
	
	// Apply overlay over the top of everything
	vec3 dodge = colour_dodge(COLOR,
		texture(overlay_dodge_texture, SKY_COORDS * overlay_uv_scale).rgb);
	COLOR = mix(COLOR, dodge, overlay_intensity);
}
