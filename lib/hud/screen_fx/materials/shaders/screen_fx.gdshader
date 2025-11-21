shader_type canvas_item;

uniform float position: hint_range(0.0, 0.5) = 0.4;
uniform float feather: hint_range(0.0, 0.5) = 0.2;
uniform float overall_alpha: hint_range(0.0, 1.0) = 1.0;

float circle(vec2 p, float r, float f) {
	return smoothstep(r, r + f, length(p - vec2(0.5)));
}

void fragment() {
	COLOR.rgb = vec3(0.0);
	COLOR.a = circle(UV, position, feather) * overall_alpha;
}
