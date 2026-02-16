#spotlight.gd
extends "res://scripts/obstacle.gd"

var light_source
var reduction

func _ready() -> void:
	can_move = true

func update_light_source() -> void:
	var light_dir = Vector2.UP
	if facing == "E":
		light_dir = Vector2.RIGHT
	elif facing == "S":
		light_dir = Vector2.DOWN
	elif facing == "W":
		light_dir = Vector2.LEFT
	light_source = global_position + light_dir * 32

func move(direction: Vector2):
	if can_move:
		if !get_area(direction):
			global_position += direction*32
			update_light_source()
			emit_signal("moved")
