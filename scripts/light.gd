extends Area2D

signal lit
var direction = Vector2.RIGHT
var parents = 0
#Level 1 reduction 0.13
#var reduction = 0.13
#Level 2 reduction 0.055
#var reduction = 0.055
var reduction

@onready var sprite = $Sprite2D
@onready var light_scene = load("res://scenes/light.tscn")

func _ready() -> void:
	await get_tree().process_frame
	var touching = get_touching()
	if (touching):
		if touching.is_in_group("mirror"):
			update_direction(touching)
		if touching.is_in_group("wall"):
			emit_signal("lit")
			queue_free()
	var still_visible = sprite.modulate.a > 0.1
	if !still_visible: emit_signal("lit")
	else:
		#Create a new light instance while light has not faded out
		var light_instance = light_scene.instantiate()
		light_instance.reduction = reduction
		print(light_instance.reduction)
		light_instance.connect("lit", func(): emit_signal("lit"))
		light_instance.parents = parents+1
		light_instance.direction = direction
		light_instance.update_position()
		add_child(light_instance)
		for parent in parents:
			light_instance.reduce_opacity(reduction)
	print("parents: "+ str(parents))
	print("opacity: "+ str(sprite.modulate.a))

#func touching_mirror() -> Area2D:
	#for area in get_overlapping_areas():
		#if area.is_in_group("mirror"):
			#return area
	#return null
func get_touching() -> Area2D:
	for mirror in get_tree().get_nodes_in_group("mirror"):
		var delta = mirror.global_position - global_position
		if abs(delta.x) < 16 and abs(delta.y) < 16:
			return mirror
	for wall in get_tree().get_nodes_in_group("wall"):
		var delta = wall.global_position - global_position
		if abs(delta.x) < 16 and abs(delta.y) < 16:
			return wall
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
