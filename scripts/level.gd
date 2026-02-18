#level.gd
extends Node2D

@onready var wall_scene = load("res://scenes/wall.tscn")
@onready var mirror_scene = load("res://scenes/mirror.tscn")
@onready var heavy_mirror_scene = load("res://scenes/heavy_mirror.tscn")
@onready var carrot_scene = load("res://scenes/carrot.tscn")
@onready var rabbit_scene = load("res://scenes/rabbit.tscn")
@onready var spotlight_scene = load("res://scenes/spotlight.tscn")
@onready var light_scene = load("res://scenes/light.tscn")

var level = 1

var rabbit
var spotlight

func _ready() -> void:
	level_four()

func reset_level():
	await get_tree().create_timer(1.0).timeout
	for child in get_children():
		child.queue_free()
	level_three()

func level_one() -> void:
	create_walls(10, 10)
	
	create_spotlight(Vector2(112.0, 304.0), "N", set_light_reduction(9))
	
	create_mirror(Vector2(80.0, 208.0), "SE")
	create_mirror(Vector2(240.0, 240.0), "NW")
	#create_mirror(Vector2(112.0, 48.0), "SW", "heavy")
	
	var carrot = carrot_scene.instantiate()
	carrot.global_position = Vector2(144.0, 48.0)
	add_child(carrot)
	
	rabbit = rabbit_scene.instantiate()
	rabbit.global_position = Vector2(48.0, 112.0)
	rabbit.connect("dead", reset_level)
	add_child(rabbit)

func level_two() -> void:
	create_walls(9, 14)
	create_wall(Vector2(48, 48))
	create_wall(Vector2(48, 80))
	create_wall(Vector2(48, 112))
	create_wall(Vector2(48, 240))
	create_wall(Vector2(208, 48))
	create_wall(Vector2(208, 80))
	create_wall(Vector2(208, 112))
	create_wall(Vector2(208, 144))
	create_wall(Vector2(240, 48))
	create_wall(Vector2(240, 80))
	create_wall(Vector2(240, 112))
	create_wall(Vector2(240, 144))
	
	create_spotlight(Vector2(48, 176), "E", set_light_reduction(16))
	
	create_mirror(Vector2(176.0, 144.0), "SW", "heavy")
	create_mirror(Vector2(176.0, 272.0), "NW", "heavy")
	create_mirror(Vector2(80.0, 368.0), "SE")
	create_mirror(Vector2(144.0, 368.0), "NE")
	
	var carrot = carrot_scene.instantiate()
	carrot.global_position = Vector2(80.0, 48.0)
	add_child(carrot)
	
	rabbit = rabbit_scene.instantiate()
	rabbit.global_position = Vector2(208.0, 368.0)
	rabbit.connect("dead", reset_level)
	add_child(rabbit)

func level_three() -> void:
	create_walls(10, 10)

	create_spotlight(Vector2(272, 80), "W", set_light_reduction(14))
	create_spotlight(Vector2(272, 112), "W", set_light_reduction(6))
	
	create_mirror(Vector2(80.0, 48.0), "SE")
	create_mirror(Vector2(176.0, 48.0), "SW")
	create_mirror(Vector2(144.0, 176.0), "NE")
	create_mirror(Vector2(176.0, 112.0), "NE")
	
	var carrot = carrot_scene.instantiate()
	carrot.global_position = Vector2(48.0, 112.0)
	add_child(carrot)
	
	rabbit = rabbit_scene.instantiate()
	rabbit.global_position = Vector2(208.0, 208.0)
	rabbit.connect("dead", reset_level)
	add_child(rabbit)

func level_four():
	create_walls(11,15)
	create_wall(grid_position(1,5))
	create_wall(grid_position(2,5))
	create_wall(grid_position(3,5))
	
	create_wall(grid_position(3,6))
	create_wall(grid_position(3,7))
	create_wall(grid_position(3,8))
	create_wall(grid_position(3,9))
	create_wall(grid_position(3,10))
	create_wall(grid_position(3,11))
	create_wall(grid_position(3,12))
	create_wall(grid_position(3,13))
	
	create_wall(grid_position(7,5))
	create_wall(grid_position(8,6))
	create_wall(grid_position(9,6))
	
	create_wall(grid_position(7,6))
	create_wall(grid_position(7,7))
	create_wall(grid_position(7,8))
	create_wall(grid_position(7,9))
	create_wall(grid_position(7,10))
	create_wall(grid_position(7,11))
	create_wall(grid_position(7,12))
	create_wall(grid_position(7,13))
	
	create_wall(grid_position(5,2))
	
	create_mirror(grid_position(2,2),"SE")
	create_mirror(grid_position(5,3),"SW")
	create_spotlight(grid_position(5,11),"N",set_light_reduction(14),true)
	
	var carrot = carrot_scene.instantiate()
	carrot.global_position = grid_position(9,5)
	add_child(carrot)
	
	rabbit = rabbit_scene.instantiate()
	rabbit.global_position = grid_position(5,13)
	rabbit.connect("dead", reset_level)
	add_child(rabbit)

func grid_position(x: int, y: int) -> Vector2:
	return Vector2(x*32+16, y*32+16)

func set_light_reduction(lights: int) -> float:
	return 0.91 / float(lights - 2)

func create_walls(width: int, height: int) -> void:
	var start_pos = Vector2(16, 16)
	var step = 32
	for y in range(height):
		for x in range(width):
			var is_border = (x == 0 or y == 0 or x == width - 1 or y == height - 1)
			if is_border:
				var wall = wall_scene.instantiate()
				wall.global_position = start_pos + Vector2(x * step, y * step)
				add_child(wall)

func create_wall(pos: Vector2):
	var wall = wall_scene.instantiate()
	wall.global_position = pos
	add_child(wall)

func create_spotlight(pos: Vector2, facing: String, reduction: float, heavy=false) -> void:
	var light = Vector2.UP
	if facing == "E":
		light = Vector2.RIGHT
	elif facing == "S":
		light = Vector2.DOWN
	elif facing == "W":
		light = Vector2.LEFT
	for area in get_tree().get_nodes_in_group("wall"):
		if area.global_position == pos:
			area.queue_free()
			create_wall(pos -32*light)
	spotlight = spotlight_scene.instantiate()
	spotlight.global_position = pos
	spotlight.reduction = reduction
	spotlight.set_facing(facing)
	spotlight.connect("moved", update_spotlight)
	add_child(spotlight)
	create_light(pos+32*(light), facing, reduction)
	if heavy: spotlight.can_move=false

func create_light(pos: Vector2, facing: String, reduction: float) -> void:
	var light = light_scene.instantiate()
	light.global_position = pos
	var light_dir = Vector2.UP
	if facing == "E":
		light_dir = Vector2.RIGHT
	elif facing == "S":
		light_dir = Vector2.DOWN
	elif facing == "W":
		light_dir = Vector2.LEFT
	light.original_direction = light_dir
	light.direction = light_dir
	light.reduction = reduction
	add_child(light)

func create_mirror(pos: Vector2, facing: String, weight="light"):
	var mirror
	if weight=="light":
		mirror = mirror_scene.instantiate()
	else:
		mirror = heavy_mirror_scene.instantiate()
	mirror.global_position = pos
	mirror.set_facing(facing)
	mirror.connect("moved", update_light)
	add_child(mirror)

func update_light() -> void:
	rabbit.can_move = false
	for child in get_children():
		if child.is_in_group("light"):
			var loc = child.global_position
			var reduction = child.reduction
			var direction = child.original_direction
			child.queue_free()
			var new_light = light_scene.instantiate()
			new_light.reduction = reduction
			new_light.global_position = loc
			new_light.original_direction = direction
			new_light.direction = direction
			print(direction)
			new_light.connect("lit", _on_light_finished)
			add_child(new_light)

func update_spotlight() -> void:
	print("Hey")
	rabbit.can_move = false
	for child in get_children():
		var reduction
		var light_dir
		if child.is_in_group("light"):
			reduction = child.reduction
			light_dir = child.original_direction
			child.queue_free()
			var new_light = light_scene.instantiate()
			new_light.global_position = spotlight.global_position + light_dir*32
			new_light.original_direction = light_dir
			new_light.direction = light_dir
			new_light.reduction = reduction
			new_light.connect("lit", _on_light_finished)
			add_child(new_light)

func _on_light_finished():
	rabbit.can_move = true
	rabbit.check_dead()
