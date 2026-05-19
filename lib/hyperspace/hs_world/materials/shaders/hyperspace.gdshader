shader_type canvas_item;

uniform bool enabled = false;
uniform float time_scale = 20.0;
uniform int fractal_count = 9;

void fragment() {
	if (enabled) {
		float s = 0.0, v = 0.0;
		vec2 ires = 1.0 / SCREEN_PIXEL_SIZE;
		vec2 uv = (FRAGCOORD.xy / ires) * 2.0 - 1.;
		float itime = (TIME + 10.0) * time_scale;
		vec3 col = vec3(0.0);
		vec3 init = vec3(sin(itime * 0.0032) * 0.3,
			0.35 - cos(itime * 0.005)* 0.3,
			itime * 0.002);
		for (int r = 0; r < 100; r++)  {
			vec3 p = init + s * vec3(uv, 0.05);
			p.z = fract(p.z);
			for (int i = 0; i < fractal_count; i++) {
				p = abs(p * 2.04) / dot(p, p) - 0.9;
			}
			v += pow(dot(p, p), 0.7) * 0.06;
			col += vec3(v * 0.2 + 0.4, 12.0 - s * 2.0, 0.1 + v * 1.0) * v * 0.00003;
			s += 0.025;
		}
		COLOR = vec4(clamp(col, 0.0, 1.0), 1.0);
	}
}
