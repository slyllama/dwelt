shader_type canvas_item;
uniform sampler2D screen_texture: hint_screen_texture, repeat_disable, filter_linear_mipmap;
uniform float blur_strength: hint_range(0.0, 2.0) = 2.0;

void fragment() {
    COLOR = textureLod(screen_texture, SCREEN_UV, 1.0);
}