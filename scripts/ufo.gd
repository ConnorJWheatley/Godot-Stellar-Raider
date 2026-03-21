extends Area2D

class_name Ufo

@export var speed = 75
@onready var laser_point: Node2D = $LaserPoint
@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	animated_sprite.play("ufo")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += delta * speed

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area is Laser:
		animated_sprite.play("destroy_ufo")
		laser_point.queue_free()
		speed = 0

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
