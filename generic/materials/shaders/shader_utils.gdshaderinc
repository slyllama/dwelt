float circle(vec2 position, float radius, float feather) {
	return smoothstep(radius, radius + feather, dot(position, position) * 4.0);
}

vec3 ripple(float circle_position, float alpha, vec2 uv, sampler2D screen_texture, vec2 screen_uv) {
	float distort_circle = circle(uv - vec2(0.5, 0.5), circle_position, 0.1);
	distort_circle += 1.0 - circle(uv - vec2(0.5, 0.5), circle_position - 0.03, 0.2);
	return(texture(screen_texture, screen_uv + (screen_uv * vec2(0.05, 1.0) * vec2(1.0 - distort_circle) * alpha * 0.2)).rgb);
}

vec3 aberration(sampler2D get_texture, vec2 uv, vec2 pixel_ratio, float intensity) {
	vec2 r_displacement = vec2(intensity, 0.0);
	vec2 g_displacement = vec2(0.0, 0.0);
	vec2 b_displacement = vec2(-intensity, 0.0);
	float r = texture(get_texture, uv + vec2(pixel_ratio * r_displacement), 0.0).r;
	float g = texture(get_texture, uv + vec2(pixel_ratio * g_displacement), 0.0).g;
	float b = texture(get_texture, uv + vec2(pixel_ratio * b_displacement), 0.0).b;
	return(vec3(r, g, b));
}
