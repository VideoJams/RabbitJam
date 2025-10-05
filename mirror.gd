extends Area2D

var facing = "NE"

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
