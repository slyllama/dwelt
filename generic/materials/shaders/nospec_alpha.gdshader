shader_type spatial;
render_mode specular_disabled, cull_disabled, shadows_disabled;

uniform sampler2D albedo_texture: source_color;
uniform vec3 albedo_color: source_color = vec3(1.0);
uniform float uv_scale = 1.0;
uniform float alpha_scissor_threshold: hint_range(0.0, 1.0) = 0.5;

void fragment() {
	vec4 _t = texture(albedo_texture, UV * uv_scale);
	ALBEDO = _t.rgb * albedo_color;
	ALPHA = _t.a;
	ALPHA_SCISSOR_THRESHOLD = alpha_scissor_threshold;
}
