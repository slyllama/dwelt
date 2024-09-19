shader_type spatial;
render_mode unshaded;

uniform vec3 color: source_color = vec3(0.0, 1.0, 1.0);
uniform float fresnel_amount = 3.0;
uniform vec3 fresnel_color: source_color = vec3(1.0, 0.0, 0.0);

float fresnel(float amount, vec3 normal, vec3 view)
{
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}

void fragment()
{
	float basic_fresnel = fresnel(fresnel_amount, NORMAL, VIEW);
	vec3 final_color = color + basic_fresnel * fresnel_color;
	ALBEDO = final_color;
	EMISSION = final_color;
}
