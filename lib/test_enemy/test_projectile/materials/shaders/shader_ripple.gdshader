shader_type spatial;
render_mode unshaded, shadows_disabled;

uniform sampler2D screen_texture: hint_screen_texture;
uniform float circle_position = 0.5;
uniform float alpha = 1.0;

float circle(vec2 position, float radius, float feather) {
	return smoothstep(radius, radius + feather, dot(position, position) * 4.0);
}

void fragment() {
	float distort_circle = circle(UV - vec2(0.5, 0.5), circle_position, 0.1);
	distort_circle += 1.0 - circle(UV - vec2(0.5, 0.5), circle_position - 0.03, 0.2);
	ALBEDO = texture(screen_texture, SCREEN_UV + (SCREEN_UV * vec2(0.05, 1.0) * vec2(1.0 - distort_circle) * alpha * 0.2)).rgb;
}
