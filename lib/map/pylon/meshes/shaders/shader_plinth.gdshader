shader_type spatial;

uniform sampler2D rock_texture: filter_linear_mipmap;
uniform sampler2D normal_texture: filter_linear_mipmap;
uniform sampler2D rock_normal_texture: filter_linear_mipmap;
uniform float rock_scale = 0.85;

void fragment() {
	ALBEDO = texture(rock_texture, UV2 * rock_scale).rgb * 0.40;
	NORMAL_MAP = mix(texture(normal_texture, UV).rgb, texture(rock_normal_texture, UV2 * rock_scale).rgb, 0.3);
	NORMAL_MAP_DEPTH = 6.0;
	ROUGHNESS = 1.0;
	METALLIC = 0.5;
}
