extends Node
# CameraData
# Provides a function to get screen-space coordinates from 3D points by
# referencing the camera

var camera: Camera3D
var camera_y_rotation: float

func world_to_screen(point) -> Vector2:
	if camera != null:
		return(camera.unproject_position(point))
	else: return(Vector2(-999, -999))
