extends Area2D

class_name Raider

@onready var animated_sprite = $AnimatedSprite2D

var config: Resource

func _ready():
	animated_sprite.play(config.anim_name)

func _on_area_entered(area: Area2D) -> void:
	if area is Laser:
		animated_sprite.play("destroy")
		area.queue_free()
		$CollisionShape2D.queue_free() # removes the hurtbox so lasers can pass through the death anim

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
