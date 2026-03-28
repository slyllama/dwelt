shader_type sky;

uniform sampler2D gradient_texture: source_color;
uniform sampler2D sky_patina_texture: source_color, hint_default_black;
uniform float sky_patina_strength = 0.014;
uniform float sky_patina_time_scale = 0.014;

// Stars
uniform sampler2D stars_texture: source_color, hint_default_black;
uniform sampler2D stars_patina_texture: hint_default_white;
uniform float stars_uv_scale = 8.0;
uniform float stars_patina_uv_scale = 2.0;

void sky() {
	COLOR = texture(gradient_texture, SKY_COORDS).rgb;
	
	// Stars
	vec3 stars = texture(stars_texture, SKY_COORDS * stars_uv_scale).rgb;
	stars *= texture(stars_patina_texture, SKY_COORDS * stars_patina_uv_scale).r;
	COLOR += stars;
	
	vec2 sky_patina_uv = SKY_COORDS + TIME * sky_patina_time_scale * vec2(1.0, 0.25);
	vec3 sky_patina = texture(sky_patina_texture, sky_patina_uv).rgb;
	COLOR -= sky_patina * sky_patina_strength;
	COLOR = clamp(COLOR, vec3(0.0), vec3(1.0));
}
