shader_type spatial;
render_mode unshaded, cull_disabled;

uniform sampler2D color_gradient_texture;
uniform sampler2D alpha_mask_texture: repeat_disable;
uniform sampler2D wobble_texture: repeat_enable;

uniform float wobble_strength: hint_range(0.0, 0.1) = 0.05;
uniform float wobble_speed: hint_range(0.0, 1.0) = 0.2;

void fragment() {
	ALBEDO = texture(color_gradient_texture, UV).rgb;
	
	// Alpha mask
	float wobble = texture(wobble_texture, UV + TIME * wobble_speed).r * wobble_strength;
	float alpha_mask = texture(alpha_mask_texture, UV + wobble).r;
	ALPHA = alpha_mask;
}
