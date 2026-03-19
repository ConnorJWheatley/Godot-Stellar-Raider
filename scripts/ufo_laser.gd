extends Node2D

@onready var spawn_timer: SpawnTimer = $SpawnTimer
var laser_scene = preload("res://scenes/raider_laser.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_timer.setup_timer()
	spawn_timer.timeout.connect(on_spawn_timer_timeout)

func on_spawn_timer_timeout():
	var laser = laser_scene.instantiate()
	var laser_sprite = laser.get_child(0)
	laser_sprite.modulate = Color(0.627, 0.235, 0.533)
	laser.global_position = global_position
	get_tree().root.add_child(laser)
	spawn_timer.setup_timer()
