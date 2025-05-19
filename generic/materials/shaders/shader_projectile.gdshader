shader_type spatial;
render_mode unshaded, depth_test_disabled;

uniform vec3 albedo: source_color = vec3(1.0);
uniform float fresnel_amount = 1.0;
uniform float fresnel_exponent: hint_range(0.1, 5.0) = 1.0;

float fresnel(float amount, vec3 normal, vec3 view) {
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}

void fragment() {
	ALBEDO = albedo;
	EMISSION = albedo;
	ALPHA = fresnel(pow(fresnel_amount, fresnel_exponent), NORMAL, VIEW);
	ALPHA = clamp(ALPHA * 1.5, 0.0, 1.0);
}
