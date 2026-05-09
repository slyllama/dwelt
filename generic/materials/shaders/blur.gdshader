shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
uniform float blur_level: hint_range(0.0, 5.0) = 0.0;

void fragment(){
	vec4 color = COLOR * texture(SCREEN_TEXTURE, SCREEN_UV, blur_level);
	COLOR = color;
}
