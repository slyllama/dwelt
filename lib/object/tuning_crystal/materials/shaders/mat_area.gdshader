shader_type spatial;
render_mode cull_disabled, shadows_disabled, fog_disabled, unshaded;
uniform sampler2D gradient;

void fragment() {
	ALBEDO = vec3(1.0, 0.0, 0.0);
	EMISSION = vec3(1.0, 0.0, 0.0);
	ALPHA = texture(gradient, UV).r;
}
