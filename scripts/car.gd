extends Node3D
class_name Car

## Car, moves along x axis with wrapping to simulate continuous directional traffic flow
var step_size: int
var left_edge_x: int
var right_edge_x: int
var current_direction: int = 1

func _physics_process(_delta: float) -> void:
	position.x += step_size * current_direction

	# Wrap around the road edges to maintain steady oncoming traffic stream
	if current_direction > 0 and position.x > right_edge_x:
		position.x = left_edge_x
	elif current_direction < 0 and position.x < left_edge_x:
		position.x = right_edge_x

	rotation.y = current_direction / 2.0 * PI
