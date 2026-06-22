shader_type spatial;
#include "res://generic/materials/shaders/utils.gdshaderinc"

uniform sampler2D stars_texture: source_color, repeat_enable;

void fragment() {
	ALBEDO = texture(stars_texture, SCREEN_UV * 8.0).rgb;
	ALBEDO += pow(fresnel(1.0, NORMAL, VIEW), 8.0) * 8.0;
	ALBEDO = clamp(ALBEDO, vec3(0.0), vec3(1.0));
	EMISSION = ALBEDO;
	
	float fade_distance = length(VERTEX);
	const vec3 magic = vec3(0.06711056, 0.00583715, 52.9829189);
	float fade = clamp(smoothstep(0.3, 0.5, fade_distance), 0.0, 1.0);
	if (fade < 0.001 || fade < fract(magic.z * fract(dot(FRAGCOORD.xy, magic.xy)))) {
		discard;
	}
}
