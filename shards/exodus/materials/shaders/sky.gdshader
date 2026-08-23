shader_type sky;

// Stars
uniform sampler2D blend_mask_texture: hint_default_black; 
uniform sampler2D a_texture: source_color, hint_default_white;
uniform sampler2D b_texture: source_color;
uniform float a_uv_scale = 1.0;
uniform float b_uv_scale = 1.0;
uniform vec3 a_albedo: source_color = vec3(1.0);
uniform vec3 b_albedo: source_color = vec3(1.0);

uniform sampler2D gradient_texture: source_color, hint_default_black;

void sky() {
	// Add colour
	vec3 a = texture(a_texture, SKY_COORDS * a_uv_scale).rgb * a_albedo;
	vec3 b = texture(b_texture, SKY_COORDS * b_uv_scale).rgb * b_albedo;
	COLOR = mix(a, b, texture(blend_mask_texture, SKY_COORDS).r);
	
	vec4 gradient = texture(gradient_texture, SKY_COORDS).rgba;
	COLOR = mix(COLOR, gradient.rgb, gradient.a);
}
