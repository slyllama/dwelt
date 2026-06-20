shader_type spatial;
render_mode depth_prepass_alpha, cull_disabled;

uniform vec4 albedo_colour: source_color = vec4(1.0);
uniform sampler2D albedo_texture: source_color, filter_linear_mipmap, repeat_enable;
uniform float uv_scale = 1.0;
uniform float backlight: hint_range(0.0, 1.0) = 0.0;
uniform bool uses_wind = true;

instance uniform bool highlight = false;

float get_wind(vec2 vertex, vec2 uv){
	float min_strength = 0.05;
	float max_strength = 0.01;
    float diff = pow(max_strength - min_strength, 2.0);
    float strength = clamp(min_strength + diff + sin(TIME / 3.5) * diff, min_strength, max_strength) * 0.7;
    float wind = (sin(TIME) + cos(TIME)) * strength * max(0.0, (1.0 - uv.y));
    return wind;
}

void vertex() {
	UV = UV * uv_scale;
	
	if (uses_wind == true) {
		UV *= 0.95;
		vec4 pos = MODEL_MATRIX * vec4(0.0, 0.0, 0.0, 1.0);
    	VERTEX.x += get_wind(VERTEX.xy, UV);
	}
}

void fragment() {
	vec4 albedo = texture(albedo_texture, UV);
	ALBEDO = albedo.rgb * albedo_colour.rgb;
	ROUGHNESS = 1.0;
	SPECULAR = 0.0;
	BACKLIGHT = vec3(backlight);
	ALPHA *= albedo.a;
	
	if (highlight == true) { ALBEDO *= 1.5; }
	
	float fade_distance = length(VERTEX);
	const vec3 magic = vec3(0.06711056, 0.00583715, 52.9829189);
	float fade = clamp(smoothstep(0.5, 1.0, fade_distance), 0.0, 1.0);
	if (fade < 0.001 || fade < fract(magic.z * fract(dot(FRAGCOORD.xy, magic.xy)))) {
		discard;
	}
}
