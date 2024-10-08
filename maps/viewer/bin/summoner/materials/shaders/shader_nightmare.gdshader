shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;
uniform float fac: hint_range(0.0, 1.0) = 0.5;

vec4 difference(vec4 base, vec4 blend){
	return abs(base - blend);
}

void fragment() {
	vec4 screen_color = texture(SCREEN_TEXTURE, SCREEN_UV).rgba;
	COLOR = mix(screen_color, vec4((1.0 - screen_color.rgb), 1.0), fac);
}
