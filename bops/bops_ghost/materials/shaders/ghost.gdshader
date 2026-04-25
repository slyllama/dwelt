shader_type spatial;
render_mode unshaded, shadows_disabled, ambient_light_disabled, cull_disabled;

uniform vec4 albedo_color: source_color = vec4(1.0);
uniform sampler2D mask: hint_default_white;

void fragment() {
	ALBEDO = albedo_color.rgb;
	ALPHA = texture(mask, UV).a;
	ALPHA *= albedo_color.a;
}
