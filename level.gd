extends Node2D

@onready var wall_scene = load("res://wall.tscn")
@onready var mirror_scene = load("res://mirror.tscn")
@onready var carrot_scene = load("res://carrot.tscn")
@onready var rabbit_scene = load("res://rabbit.tscn")
@onready var light_scene = load("res://light.tscn")

var light_direction = Vector2.UP
var light_reduction = 0.33
var level = 1

func _ready() -> void:
	level_one()

func level_one() -> void:
	##Create walls
	create_walls(10, 10)
	
	##Create light
	var light = light_scene.instantiate()
	light.global_position = Vector2(112.0, 272.0)
	light.direction = light_direction
	light.reduction = light_reduction
	add_child(light)
	
	##Create mirrors
	create_mirror(Vector2(80.0, 208.0), "SE")
	create_mirror(Vector2(240.0, 240.0), "NW")
	
	##Create carrot
	var carrot = carrot_scene.instantiate()
	carrot.global_position = Vector2(144.0, 48.0)
	add_child(carrot)
	
	##Create rabbit
	var rabbit = rabbit_scene.instantiate()
	rabbit.global_position = Vector2(48.0, 112.0)
	rabbit.connect("dead", reset_level)
	add_child(rabbit)

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

func create_mirror(pos: Vector2, facing: String):
	var mirror = mirror_scene.instantiate()
	mirror.global_position = pos
	if facing:
		mirror.set_facing(facing)
	mirror.connect("moved", update_light)
	add_child(mirror)

func reset_level():
	await get_tree().create_timer(1.0).timeout
	for child in get_children():
		child.queue_free()
	level_one()

func update_light() -> void:
	for child in get_children():
		if child.is_in_group("light"):
			var loc = child.global_position
			child.queue_free()
			var new_light = light_scene.instantiate()
			new_light.global_position = loc
			new_light.direction = light_direction
			add_child(new_light)
