shader_type spatial;
render_mode specular_disabled;

uniform sampler2D albedo_texture: source_color;
uniform vec3 albedo_color: source_color = vec3(1.0);
uniform float uv_scale = 1.0;


void fragment() {
	ALBEDO = texture(albedo_texture, UV * uv_scale).rgb * albedo_color;
}
