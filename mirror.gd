extends Area2D

var facing = "NE"
signal moved

func set_facing(direction: String) -> void:
	facing = direction
	if facing == "NE":
		rotation = 0
	elif facing == "SE":
		rotation = PI/2
	elif facing == "SW":
		rotation = PI
	elif facing == "NW":
		rotation = (3*PI)/2

func move(direction: Vector2):
	if !get_area(direction):
		global_position += direction*32
		emit_signal("moved")

func get_area(direction: Vector2) -> Area2D:
	var target_pos = global_position + direction * 32
	
	for area in get_tree().get_nodes_in_group("wall") + get_tree().get_nodes_in_group("mirror"):
		if area.global_position == target_pos:
			return area
	
	return null
