shader_type spatial;
render_mode cull_disabled, unshaded, depth_test_disabled, depth_prepass_alpha;

uniform vec4 albedo_colour: source_color = vec4(1.0);
uniform sampler2D albedo_texture: source_color, filter_linear_mipmap, repeat_enable;
uniform float uv_scale = 1.0;
uniform float backlight: hint_range(0.0, 1.0) = 0.0;

instance uniform bool highlight = false;

void fragment() {
	vec4 albedo = texture(albedo_texture, UV);
	ALBEDO = albedo.rgb * albedo_colour.rgb;
	ROUGHNESS = 1.0;
	SPECULAR = 0.0;
	BACKLIGHT = vec3(backlight);
	ALPHA *= albedo.a;
	
	if (highlight == true) { ALBEDO *= 1.5; }
}
