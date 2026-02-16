extends Node2D

@onready var wall_scene = load("res://scenes/wall.tscn")
@onready var mirror_scene = load("res://scenes/mirror.tscn")
@onready var heavy_mirror_scene = load("res://scenes/heavy_mirror.tscn")
@onready var carrot_scene = load("res://scenes/carrot.tscn")
@onready var rabbit_scene = load("res://scenes/rabbit.tscn")
@onready var spotlight_scene = load("res://scenes/spotlight.tscn")
@onready var light_scene = load("res://scenes/light.tscn")

var light_updating = false
var light_direction = Vector2.UP
#var light_reduction = 0.055
var light_reduction
var level = 1

var rabbit
var spotlight

func _ready() -> void:
	level_one()

func reset_level():
	await get_tree().create_timer(1.0).timeout
	for child in get_children():
		child.queue_free()
	level_one()

func level_one() -> void:
	set_light_reduction(9)
	create_walls(10, 10)
	
	create_spotlight(Vector2(112.0, 304.0), "N")
	
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
	set_light_reduction(16)
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
	
	create_spotlight(Vector2(48, 176), "E")
	
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

	create_spotlight(Vector2(272, 80), "W")
	create_spotlight(Vector2(272, 112), "W")
	
	create_mirror(Vector2(80.0, 48.0), "SE")
	create_mirror(Vector2(176.0, 272.0), "SW")
	create_mirror(Vector2(144.0, 176.0), "NE")
	create_mirror(Vector2(176.0, 112.0), "NE")
	
	var carrot = carrot_scene.instantiate()
	carrot.global_position = Vector2(80.0, 48.0)
	add_child(carrot)
	
	rabbit = rabbit_scene.instantiate()
	rabbit.global_position = Vector2(208.0, 368.0)
	rabbit.connect("dead", reset_level)
	add_child(rabbit)

func set_light_reduction(lights: int) -> void:
	light_reduction = 0.91 / float(lights - 2)

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

func create_spotlight(pos: Vector2, facing: String) -> void:
	var light = Vector2.UP
	if facing == "E":
		light = Vector2.RIGHT
	elif facing == "S":
		light = Vector2.DOWN
	elif facing == "W":
		light = Vector2.LEFT
	light_direction = light
	for area in get_tree().get_nodes_in_group("wall"):
		if area.global_position == pos:
			area.queue_free()
			create_wall(pos -32*light)
	spotlight = spotlight_scene.instantiate()
	spotlight.global_position = pos
	spotlight.set_facing(facing)
	spotlight.connect("moved", update_spotlight)
	add_child(spotlight)
	create_light(pos+32*(light), facing)

func create_light(pos: Vector2, facing: String) -> void:
	var light = light_scene.instantiate()
	light.global_position = pos
	var light_dir = Vector2.UP
	if facing == "E":
		light_dir = Vector2.RIGHT
	elif facing == "S":
		light_dir = Vector2.DOWN
	elif facing == "W":
		light_dir = Vector2.LEFT
	light.direction = light_dir
	light.reduction = light_reduction
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
			child.queue_free()
			var new_light = light_scene.instantiate()
			new_light.reduction = light_reduction
			new_light.global_position = loc
			new_light.direction = light_direction
			new_light.connect("lit", _on_light_finished)
			add_child(new_light)

func update_spotlight() -> void:
	rabbit.can_move = false
	for child in get_children():
		if child.is_in_group("light"):
			child.queue_free()
	var new_light = light_scene.instantiate()
	var light_dir = Vector2.UP
	if spotlight.facing == "E":
		light_dir = Vector2.RIGHT
	elif spotlight.facing == "S":
		light_dir = Vector2.DOWN
	elif spotlight.facing == "W":
		light_dir = Vector2.LEFT
	new_light.global_position = spotlight.global_position + light_dir*32
	new_light.direction = light_dir
	new_light.reduction = light_reduction
	new_light.connect("lit", _on_light_finished)
	add_child(new_light)

func _on_light_finished():
	print("LIT")
	rabbit.can_move = true
	rabbit.check_dead()
