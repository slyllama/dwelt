shader_type spatial;
render_mode unshaded;

uniform sampler2D crystal_texture: source_color;
uniform sampler2D wobble_mask: hint_default_black;
uniform float uv_scale = 2.0;

void fragment() {
	float _w = texture(wobble_mask, UV * 0.65 + TIME * 0.05).r;
	ALBEDO = texture(crystal_texture, UV * uv_scale + _w * 0.06).rgb;
}
