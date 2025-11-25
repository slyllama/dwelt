shader_type spatial;
render_mode unshaded, cull_disabled;

uniform sampler2D length_mask_texture: repeat_disable, filter_linear;
uniform sampler2D smoke_mask_texture: repeat_enable, filter_linear;

void fragment() {
	ALPHA = texture(length_mask_texture, UV).r;
	ALPHA *= texture(smoke_mask_texture, UV * 0.1 + TIME * vec2(1.0, 0.0) * 0.01).r;
}

