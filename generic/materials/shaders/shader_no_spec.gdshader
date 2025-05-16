shader_type spatial;

uniform sampler2D albedo_texture: hint_default_black;
uniform vec3 albedo: source_color = vec3(1.0);
uniform float uv_scale: hint_range(0.1, 50.0) = 1.0;

void fragment() {
	ALBEDO = texture(albedo_texture, UV * uv_scale).rgb * albedo;
	SPECULAR = 0.0;
}
