shader_type spatial;
render_mode unshaded, shadows_disabled, ambient_light_disabled, fog_disabled;

#include "res://generic/materials/shaders/utils.gdshaderinc"

uniform sampler2D SCREEN_TEXTURE: filter_linear_mipmap, hint_screen_texture, repeat_disable;
uniform sampler2D wobble_texture: filter_linear_mipmap, repeat_enable;
uniform float light_strength: hint_range(0.0, 1.0) = 0.85;
uniform float wobble_strength: hint_range(0.0, 1.0) = 0.1;
uniform float wobble_speed: hint_range(0.0, 2.0) = 0.07;

void vertex() {
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
		MAIN_CAM_INV_VIEW_MATRIX[0],
		MAIN_CAM_INV_VIEW_MATRIX[1],
		MAIN_CAM_INV_VIEW_MATRIX[2],
		MODEL_MATRIX[3]);
	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
}

void fragment() {
	vec3 s = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
	vec2 w_uv = texture(wobble_texture, UV + TIME * wobble_speed).rg;
	vec3 w = texture(SCREEN_TEXTURE, SCREEN_UV + w_uv * wobble_strength * 0.1).rgb;
	ALBEDO = mix(s, w, 1.0 - circle(UV, 0.3, 0.2));
	ALBEDO = color_dodge(ALBEDO, vec3(1.0 - circle(UV, 0.0, 0.5)) * light_strength);
	ALBEDO = clamp(ALBEDO, 0.0, 1.0);
}
