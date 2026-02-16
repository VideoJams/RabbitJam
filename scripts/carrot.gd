extends Area2D

var collectible = false

@onready var sprite = $AnimatedSprite2D

func _ready() -> void:
	sprite.set_frame_and_progress(0,0)

func _on_area_entered(area: Area2D) -> void:
	if (area.is_in_group("light")):
		if !collectible:
			sprite.play("grow")
			collectible = true
