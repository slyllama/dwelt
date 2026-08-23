shader_type sky;

uniform sampler2D gradient_texture: source_color, hint_default_black;

void sky() {
	COLOR = texture(gradient_texture, SKY_COORDS).rgb;
}
