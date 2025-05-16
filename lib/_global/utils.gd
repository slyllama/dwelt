extends Node
# Utils
# Contains useful functions.

# Critical lerp - truly framerate-independent
func crit_lerp(delta: float, speed: float) -> float:
	return(clamp(1.0 - exp(-speed * delta), 0.0, 1.0))

# Pretty (and rounded) presentation of Vector3 values
func fmt_vec3(vec: Vector3) -> String:
	return(str(snapped(vec.x, 0.1))
		+ ", " + str(snapped(vec.y, 0.1))
		+ ", " + str(snapped(vec.z, 0.1)))
