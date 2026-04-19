shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, unshaded, shadows_disabled;

uniform float proximity_fade_distance: hint_range(0.0, 4096.0, 0.01);
uniform sampler2D depth_texture: hint_depth_texture, repeat_disable, filter_nearest;
uniform sampler2D noise_texture: repeat_enable, filter_linear_mipmap;
uniform vec3 albedo_color: source_color;

void fragment() {
	float proximity_depth_tex = textureLod(depth_texture, SCREEN_UV, 0.0).r;
	vec4 proximity_view_pos = INV_PROJECTION_MATRIX * vec4(SCREEN_UV * 2.0 - 1.0, proximity_depth_tex, 1.0);
	proximity_view_pos.xyz /= proximity_view_pos.w;
	ALBEDO = albedo_color;
	ALPHA *= pow(texture(noise_texture, UV * 7.0 + TIME * 0.1).r, 2.0);
	ALPHA *= clamp(smoothstep(proximity_view_pos.z + proximity_fade_distance, proximity_view_pos.z, VERTEX.z), 0.0, 1.0);
	ALPHA = clamp(ALPHA, 0.0, 1.0);
}
