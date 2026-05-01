shader_type spatial;

uniform vec4 albedo_colour: source_color = vec4(1.0);
uniform sampler2D albedo_texture: source_color, filter_linear_mipmap, repeat_enable;
uniform float roughness: hint_range(0.0, 1.0) = 1.0;
uniform sampler2D roughness_texture: hint_roughness_r, filter_linear_mipmap, repeat_enable;
uniform sampler2D normal_texture: hint_normal;

uniform float specular: hint_range(0.0, 1.0, 0.01) = 0.5;
uniform float metallic: hint_range(0.0, 1.0, 0.01) = 0.0;
uniform float backlight: hint_range(0.0, 1.0, 0.01) = 0.0;
uniform float normal_strength: hint_range(0.0, 1.0, 0.01) = 0.0;
uniform float uv_scale = 1.0;
uniform bool use_alpha = false;

instance uniform bool highlight = false;

void vertex() {
	UV = UV * uv_scale;
}

void fragment() {
	vec4 albedo = texture(albedo_texture, UV);
	ALBEDO = albedo.rgb * albedo_colour.rgb;
	SPECULAR = specular;
	METALLIC = metallic;
	BACKLIGHT = vec3(backlight);
	
	vec4 roughness_texture_channel = vec4(1.0, 0.0, 0.0, 0.0);
	float roughness_tex = dot(texture(roughness_texture, UV), roughness_texture_channel);
	ROUGHNESS = roughness_tex * roughness;
	
	if (normal_strength > 0.0) {
		NORMAL_MAP = texture(normal_texture, UV).rgb;
		NORMAL_MAP_DEPTH = normal_strength;
	}
	
	if (highlight == true) { ALBEDO *= 1.5; }
	
	float fade_distance = length(VERTEX);
	const vec3 magic = vec3(0.06711056, 0.00583715, 52.9829189);
	float fade = clamp(smoothstep(0.0, 0.75, fade_distance), 0.0, 1.0);
	if (fade < 0.001 || fade < fract(magic.z * fract(dot(FRAGCOORD.xy, magic.xy)))) {
		discard;
	}
}
