extends Node2D

@onready var mirror_scene = load("res://mirror.tscn")

func _ready() -> void:
	var mirror = mirror_scene.instantiate()
	mirror.global_position = Vector2(144.0, 48.0)
	mirror.set_facing("SW")
	add_child(mirror)
	
	var mirror2 = mirror_scene.instantiate()
	mirror2.global_position = Vector2(144.0, 144.0)
	add_child(mirror2)
	
	var mirror3 = mirror_scene.instantiate()
	mirror3.global_position = Vector2(272.0, 144.0)
	mirror3.set_facing("NW")
	add_child(mirror3)
