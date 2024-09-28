shader_type spatial;

uniform sampler2D rock_texture: filter_linear_mipmap;
uniform sampler2D normal_texture: filter_linear_mipmap;
uniform sampler2D rock_normal_texture: filter_linear_mipmap;
uniform float rock_scale = 1.0;

void fragment() {
	ALBEDO = texture(rock_texture, UV2 * rock_scale).rgb * 0.15 - 0.01;
	NORMAL_MAP = mix(texture(normal_texture, UV).rgb, texture(rock_normal_texture, UV2 * rock_scale).rgb, 0.2);
	NORMAL_MAP_DEPTH = 6.0;
	SPECULAR = 0.0;
}
