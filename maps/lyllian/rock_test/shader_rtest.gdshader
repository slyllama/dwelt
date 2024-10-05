shader_type spatial;

uniform sampler2D normal: hint_normal;
uniform sampler2D rock;
uniform sampler2D rock_normal: hint_normal;
uniform sampler2D noise;

void fragment() {
	vec3 rock1 = texture(rock, UV2 * 12.0).rgb * 0.1 - 0.010;
	vec3 rock2 = texture(rock, UV2 * 6.0).rgb * 0.1 - 0.024;
	ALBEDO = mix(rock1, rock2, texture(noise, UV2).r);
	
	vec3 norm_tex = texture(normal, UV).rgb;
	vec3 rock_norm_tex = texture(rock_normal, UV2 * 12.0).rgb;
	SPECULAR = 0.0;
	NORMAL_MAP = mix(norm_tex, rock_norm_tex, 0.45);
	NORMAL_MAP_DEPTH = 4.0;
}
