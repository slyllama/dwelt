shader_type sky;

uniform sampler2D gradient_texture: source_color;
uniform sampler2D patina_mask: source_color;
uniform sampler2D sky_patina_texture: source_color, hint_default_black;
uniform float sky_patina_strength = 0.014;
uniform float sky_patina_time_scale = 0.014;

void sky() {
	COLOR = texture(gradient_texture, SKY_COORDS).rgb;
	
	vec2 sky_patina_uv = SKY_COORDS + TIME * sky_patina_time_scale * vec2(1.0, 0.25);
	vec3 sky_patina = texture(sky_patina_texture, sky_patina_uv).rgb;
	sky_patina *= texture(patina_mask, SKY_COORDS).r;
	COLOR -= sky_patina * sky_patina_strength;
	COLOR = clamp(COLOR, vec3(0.0), vec3(1.0));
}
