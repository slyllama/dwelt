shader_type sky;

uniform sampler2D gradient_texture: source_color;

void sky() {
	COLOR = texture(gradient_texture, SKY_COORDS).rgb;
}
