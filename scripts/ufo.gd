extends Area2D

class_name Ufo

signal ufo_destroyed(points: int)

@export var speed = 75
@onready var laser_point: Node2D = $LaserPoint
@onready var animated_sprite = $AnimatedSprite2D

@export var config: Resource
var ufo_point_multipliers = [1.5, 2, 2.5, 3, 3.5, 4]
var points: int

func _ready():
	animated_sprite.play("ufo")
	points = config.points

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
		# generate new number for UFO points based on a base value and a multiplier
		var rand_multiplier = ufo_point_multipliers[randi() % ufo_point_multipliers.size()]
		var new_points: int = points * rand_multiplier
		ufo_destroyed.emit(new_points)

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
	
