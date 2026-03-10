shader_type spatial;
render_mode cull_disabled, specular_disabled;

uniform vec3 modulate: source_color = vec3(1.0);
uniform sampler2D foliage_texture: source_color, filter_linear_mipmap, repeat_enable;
uniform sampler2D foliage_normal_texture: hint_normal, filter_linear_mipmap;
uniform float alpha_scissor_threshold: hint_range(0.0, 1.0) = 0.95;
uniform float normal_map_depth: hint_range(0.0, 1.0) = 1.0;
uniform float fade_length = 18.0;
uniform bool uses_wind = true;

float get_wind(vec2 vertex, vec2 uv){
	float min_strength = 0.05;
	float max_strength = 0.01;
    float diff = pow(max_strength - min_strength, 2.0);
    float strength = clamp(min_strength + diff + sin(TIME / 3.5) * diff, min_strength, max_strength) * 0.7;
    float wind = (sin(TIME) + cos(TIME)) * strength * max(0.0, (1.0 - uv.y));
    return wind;
}

void vertex() {
	if (uses_wind == true) {
		UV *= 0.95;
		vec4 pos = MODEL_MATRIX * vec4(0.0, 0.0, 0.0, 1.0);
    	VERTEX.x += get_wind(VERTEX.xy, UV);
	}
}

void fragment() {
	vec4 foliage = texture(foliage_texture, UV);
	ALBEDO = foliage.rgb;
	ALBEDO *= modulate;
	ALBEDO *= COLOR.rgb;
	NORMAL_MAP = texture(foliage_normal_texture, UV).rgb;
	NORMAL_MAP_DEPTH = 1.0;
	
	ALPHA = foliage.a;
	ALPHA_SCISSOR_THRESHOLD = alpha_scissor_threshold;
	SPECULAR = 0.0;
	EMISSION = ALBEDO * 0.1;
	BACKLIGHT = vec3(0.5);
	
	float fade_distance = length(VERTEX);
	const vec3 magic = vec3(0.06711056, 0.00583715, 52.9829189);
	float fade = clamp(smoothstep(1.0, 1.5, fade_distance), 0.0, 1.0);
	if (fade < 0.001 || fade < fract(magic.z * fract(dot(FRAGCOORD.xy, magic.xy)))) {
		discard;
	}
	float dist_fade = clamp(smoothstep(fade_length, fade_length - 1.0, fade_distance), 0.0, 1.0);
	if (dist_fade < 0.001 || dist_fade < fract(magic.z * fract(dot(FRAGCOORD.xy, magic.xy)))) {
		discard;
	}
}
