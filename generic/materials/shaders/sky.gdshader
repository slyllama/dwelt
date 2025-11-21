shader_type sky;

uniform sampler2D albedo_texture: source_color;
uniform sampler2D clouds: source_color, repeat_enable, filter_linear;
uniform sampler2D clouds_mask: source_color;

void sky() {
	COLOR = texture(albedo_texture, SKY_COORDS + 0.01).rgb;
	COLOR += texture(clouds, SKY_COORDS * 1.0 + SKY_COORDS.y * 0.5 + TIME * 0.005).rgb * 0.45 * texture(clouds_mask, SKY_COORDS).r;
}
