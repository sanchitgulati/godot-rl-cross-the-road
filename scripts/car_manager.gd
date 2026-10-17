extends Node3D
class_name CarManager

@export var map: Map
@export var car_scene: PackedScene

var car_left_edge_x: int
var car_right_edge_x: int

@onready var cars: Array[Node] = get_children()

func _ready() -> void:
	for road_row_idx in map.road_rows.size():
		create_car()
	reset()


func create_car():
	var new_car = car_scene.instantiate()
	add_child(new_car)
	cars.append(new_car)


func reset():
	while cars.size() > map.road_rows.size():
		cars[cars.size() - 1].queue_free()
		cars.remove_at(cars.size() - 1)
		
	while cars.size() < map.road_rows.size():
		create_car()

	# Set car properties and opposing traffic directions
	for car_id in cars.size():
		var car = cars[car_id]
		car.left_edge_x = 0
		car.right_edge_x = (map.grid_size_x - 1) * map.tile_size
		car.step_size = map.tile_size
		
		car.position.x = range(car.left_edge_x + 2, car.right_edge_x - 2, 2).pick_random()
		car.position.y = map.tile_size / 2 + 0.75
		car.position.z = map.road_rows[car_id] * 2

		# Alternating bidirectional traffic across lanes:
		# Lane 0 (Row 2): Eastbound (+1)
		# Lane 1 (Row 3): Westbound (-1, coming from opposite direction)
		# Lane 2 (Row 4): Eastbound (+1)
		if car_id % 2 == 0:
			car.current_direction = 1
		else:
			car.current_direction = -1
		car.rotation.y = car.current_direction / 2.0 * PI
