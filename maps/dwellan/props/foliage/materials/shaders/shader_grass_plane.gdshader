shader_type spatial;
// grass_plane

uniform sampler2D grass_texture: filter_linear_mipmap, repeat_enable;
uniform sampler2D mix_noise: filter_linear_mipmap, repeat_enable;
uniform sampler2D normal_noise: repeat_enable;

vec2 rotate(vec2 uv, vec2 pivot, float angle) {
	mat2 rotation = mat2(vec2(sin(angle), -cos(angle)), vec2(cos(angle), sin(angle)));
	uv -= pivot;
	uv = uv * rotation;
	uv += pivot;
	return(uv);
}

void fragment() {
	vec3 grass_layer_1 = texture(grass_texture, rotate(UV, vec2(0.5, 0.5), 45.0) * 7.0).rgb;
	vec3 grass_layer_2 = texture(grass_texture, UV * 4.5).rgb * 0.6;
	vec3 mix_layer = texture(mix_noise, UV).rgb;
	vec3 grass_mix = mix(grass_layer_1, grass_layer_2, mix_layer);

	SPECULAR = 0.0;
	NORMAL_MAP_DEPTH = 0.5;
	NORMAL_MAP = texture(normal_noise, UV * 12.0).rgb;
	ALBEDO = grass_mix * 0.30 - 0.03;
}
