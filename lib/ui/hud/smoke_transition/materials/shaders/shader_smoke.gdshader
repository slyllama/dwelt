shader_type canvas_item;

uniform sampler2D smoke_effect: filter_linear_mipmap, repeat_enable;
uniform sampler2D wobble_pattern: filter_linear_mipmap, repeat_enable;
uniform vec3 base_color: source_color = vec3(0.0, 0.0, 0.0);

uniform float size: hint_range(0.0, 1.0) = 0.5;
uniform float exponent: hint_range(0.0, 5.0) = 1.0;
uniform float darkness: hint_range(0.0, 1.0) = 0.5;
uniform float overall_alpha: hint_range(0.0, 1.0) = 1.0;
uniform float overall_scale = 1.5;
uniform float time_factor = 0.1;

const vec2 center = vec2(0.5, 0.5);

void fragment() {
	float adj_size = size / 1.2;
	float ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y * 1.5;
	vec2 scaled_uv = (SCREEN_UV - vec2(0.5, 0.0)) / vec2(ratio, 1.0) + vec2(0.5, 0.0);
	float mask = (1.0 - smoothstep(adj_size, adj_size - 0.25, length(scaled_uv - center)));
	
	vec2 wobble = texture(wobble_pattern, SCREEN_UV + TIME * time_factor).r * 0.1 * vec2(1, 1);
	vec3 smoke = texture(smoke_effect, scaled_uv * overall_scale + wobble).rgb;
	
	smoke = smoke * vec3(mask);
	smoke = smoke + vec3(mask) * darkness;
	COLOR.rgba = vec4(base_color, pow(smoke.r, exponent) * overall_alpha);
}
