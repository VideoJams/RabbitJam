extends Area2D

var direction = Vector2.RIGHT
var parents = 0



@onready var sprite = $Sprite2D

func _ready() -> void:
	await get_tree().process_frame
	var mirror = touching_mirror()
	if (mirror):
		update_direction(mirror)
	var still_visible = sprite.modulate.a > 0
	if (still_visible):
		#Create a new light instance while light has not faded out
		var light_scene = load("res://light.tscn")
		var light_instance = light_scene.instantiate()
		add_child(light_instance)
		light_instance.parents = parents+1
		light_instance.direction = direction
		light_instance.update_position()
		for parent in parents:
			light_instance.reduce_opacity(0.05)

#func touching_mirror() -> Area2D:
	#for area in get_overlapping_areas():
		#if area.is_in_group("mirror"):
			#return area
	#return null
func touching_mirror() -> Area2D:
	for mirror in get_tree().get_nodes_in_group("mirror"):
		var delta = mirror.global_position - global_position
		if abs(delta.x) < 16 and abs(delta.y) < 16:
			return mirror
	return null

func update_direction(mirror: Area2D) -> void:
	match mirror.facing:
		"NE":
			if direction == Vector2.LEFT:
				direction = Vector2.UP
			elif direction == Vector2.DOWN:
				direction = Vector2.RIGHT
			else: reduce_opacity(1)
		"NW":
			if direction == Vector2.RIGHT:
				direction = Vector2.UP
			elif direction == Vector2.DOWN:
				direction = Vector2.LEFT
			else: reduce_opacity(1)
		"SE":
			if direction == Vector2.LEFT:
				direction = Vector2.DOWN
			elif direction == Vector2.UP:
				direction = Vector2.RIGHT
			else: reduce_opacity(1)
		"SW":
			if direction == Vector2.RIGHT:
				direction = Vector2.DOWN
			elif direction == Vector2.UP:
				direction = Vector2.LEFT
			else: reduce_opacity(1)

func update_position() -> void:
	position += direction*32

func reduce_opacity(val: float):
	sprite.modulate.a -= val
