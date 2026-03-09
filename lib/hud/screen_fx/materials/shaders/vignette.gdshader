shader_type canvas_item;
#include "res://generic/materials/shaders/utils.gdshaderinc"

uniform float position: hint_range(0.0, 0.5) = 0.5;
uniform float feather: hint_range(0.0, 0.5) = 0.2;
uniform float alpha: hint_range(0.0, 1.0) = 1.0;

void fragment() {
	COLOR.rgb = vec3(0.0);
	COLOR.a = circle(UV, position, feather) * alpha;
}
