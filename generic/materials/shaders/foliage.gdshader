shader_type spatial;
render_mode cull_disabled, specular_disabled;

const vec3 magic = vec3(0.06711056, 0.00583715, 52.9829189);

uniform vec3 modulate: source_color = vec3(1.0);
uniform sampler2D foliage_texture: source_color, filter_linear_mipmap, repeat_enable;
uniform float alpha_scissor_threshold: hint_range(0.0, 1.0) = 0.95;
uniform float fade_threshold = 7.0;

float get_wind(vec2 vertex, vec2 uv) {
	float min_strength = 0.01;
	float max_strength = 0.03;
    float diff = pow(max_strength - min_strength, 2.0);
    float strength = clamp(min_strength + diff + sin(TIME / 3.5) * diff, min_strength, max_strength) * 0.7;
    float wind = (sin(TIME) + cos(TIME)) * strength * max(0.0, (1.0 - uv.y));
    return wind;
}

bool fade(float min_fade, float max_fade, vec3 vertex, vec4 fragcoord) {
	float fade_distance = length(vertex);
	float fade_near = clamp(smoothstep(min_fade, max_fade, fade_distance), 0.0, 1.0);
	if (fade_near < 0.001 || fade_near < fract(magic.z * fract(dot(fragcoord.xy, magic.xy)))) {
		return(true);
	} else { return(false); }
}

void vertex() {
	UV *= 0.95;
    VERTEX.x += get_wind(VERTEX.xy, UV);
}

void fragment() {
	vec4 foliage = texture(foliage_texture, UV);
	ALBEDO = foliage.rgb;
	ALBEDO *= modulate;
	ALBEDO *= COLOR.rgb;
	EMISSION = ALBEDO * 0.5;

	ALPHA = foliage.a;
	ALPHA_SCISSOR_THRESHOLD = alpha_scissor_threshold;
	
	if (fade(0.6, 0.7, VERTEX, FRAGCOORD) == true) { discard; }
	if (fade(fade_threshold, fade_threshold - 0.5, VERTEX, FRAGCOORD) == true) { discard; }
}
