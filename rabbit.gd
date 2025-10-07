extends Area2D

var facing_left = true
var alive = true
signal dead

@onready var sprite = $Sprite2D

func _process(delta: float) -> void:
	if alive:
		if Input.is_action_just_pressed("ui_up"):
			handle_move(Vector2.UP)
		elif Input.is_action_just_pressed("ui_right"):
			handle_move(Vector2.RIGHT)
		elif Input.is_action_just_pressed("ui_down"):
			handle_move(Vector2.DOWN)
		elif Input.is_action_just_pressed("ui_left"):
			handle_move(Vector2.LEFT)

func handle_move(direction: Vector2):
	var check_area = get_area(direction)
	if !check_area:
		move(direction)
	elif check_area.is_in_group("mirror"):
		check_area.move(direction)
	elif check_area.is_in_group("carrot"):
		move(direction)
		if check_area.collectible:
			if alive:
				check_area.queue_free()
				print("WIN")
	elif check_area.is_in_group("wall"):
		pass

func get_area(direction: Vector2) -> Area2D:
	var target_pos = global_position + direction * 32
	
	for area in get_tree().get_nodes_in_group("mirror") + get_tree().get_nodes_in_group("carrot") + get_tree().get_nodes_in_group("wall"):
		if area.global_position == target_pos:
			return area
	
	return null

func move(direction: Vector2):
	if direction == Vector2.LEFT:
		if !facing_left:
			facing_left = true
			sprite.flip_h = false
	elif direction == Vector2.RIGHT:
		if facing_left:
			facing_left = false
			sprite.flip_h = true
	global_position += direction*32
	for area in get_tree().get_nodes_in_group("light"):
		if area.global_position == global_position:
			if alive:
				alive = false
				sprite.flip_v = true
				emit_signal("dead")
