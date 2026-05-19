shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear;
uniform float position: hint_range(0.0, 0.5) = 0.4;
uniform float feather: hint_range(0.0, 0.5) = 0.2;
uniform float strength = 5.0;

float circle(vec2 p, float r, float f) {
	return(smoothstep(r, r + f, length(p - vec2(0.5))));
}

void fragment() {
	float r = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE * strength), 0.0).r;
	float g = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE), 0.0).g;
	float b = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE * strength * -1.0), 0.0).b;
	vec4 screen = vec4(texture(SCREEN_TEXTURE, SCREEN_UV).rgb, 1.0);
	vec4 abberation = vec4(r, g, b, 1.0);
	float mask = circle(UV, position, feather);
	COLOR = mix(screen, abberation, mask);
}
