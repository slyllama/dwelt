float circle(vec2 p, float r, float f) {
	return(smoothstep(r, r + f, length(p - vec2(0.5))));
}

vec3 color_dodge(vec3 base, vec3 blend){
	return(base / (1.0 - blend));
}

vec2 rotate(vec2 uv, vec2 pivot, float angle) {
	mat2 rotation = mat2(vec2(sin(angle), -cos(angle))
		, vec2(cos(angle), sin(angle)));
	uv -= pivot;
	uv = uv * rotation;
	uv += pivot;
	return uv;
}
