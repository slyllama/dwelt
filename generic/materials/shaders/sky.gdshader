shader_type sky;

uniform sampler2D albedo_texture: source_color;
uniform sampler2D clouds: source_color, repeat_enable, filter_linear;
uniform sampler2D smoke: source_color, repeat_enable, filter_linear;
uniform sampler2D stars: source_color, repeat_enable, filter_linear;
uniform sampler2D clouds_mask: source_color;

void sky() {
	float _cm = texture(clouds_mask, SKY_COORDS).r; // cloud mask
	vec2 _uv = SKY_COORDS * 1.0 + SKY_COORDS.y * 0.;
	vec3 _sm = texture(smoke, SKY_COORDS * 4.0 - TIME * 0.005).rgb * _cm;

	_uv += TIME * 0.005;
	COLOR = texture(albedo_texture, SKY_COORDS + 0.01).rgb;
	COLOR *= 1.0 + (texture(stars, SKY_COORDS * 15.0).rgb) * (1.0 - _cm);
	COLOR += texture(clouds, _uv).rgb * 0.45 * _cm;
	COLOR *= (1.0 + _sm * 0.45);
	COLOR = clamp(COLOR, 0.0, 1.0);
}
