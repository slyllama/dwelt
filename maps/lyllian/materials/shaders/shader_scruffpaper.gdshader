shader_type spatial;

uniform sampler2D wallpaper_texture: filter_linear_mipmap, repeat_enable;
uniform sampler2D wallpaper_normal: filter_linear_mipmap, repeat_enable;
uniform sampler2D wallpaper_grunge: filter_linear_mipmap, repeat_enable;
uniform float uv_scale = 12.0;
uniform float grunge_scale = 2.0;

void fragment() {
	ALBEDO = texture(wallpaper_texture, UV * uv_scale).rgb * 0.14 - 0.025;
	vec3 grunge = texture(wallpaper_grunge, UV * grunge_scale).rgb;
	grunge = clamp(grunge * 0.023, 0, 0.012);

	ALBEDO -= grunge;
	NORMAL_MAP = texture(wallpaper_normal, UV * uv_scale).rgb;
	SPECULAR = 0.0;
}
