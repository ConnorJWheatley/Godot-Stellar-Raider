extends Area2D

class_name Ufo

@export var speed = 75
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var laser_point: Node2D = $LaserPoint

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += delta * speed

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
