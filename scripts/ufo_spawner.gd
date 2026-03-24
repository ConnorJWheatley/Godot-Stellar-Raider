extends Node2D

class_name UfoSpawner

signal ufo_destroyed_spawn(points: int)

@onready var spawn_timer: Timer = $SpawnTimer
var ufo_scene: PackedScene = preload("res://scenes/ufo.tscn")
var ufo_point_multipliers = [1.5, 2, 2.5, 3, 3.5, 4]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_timer.setup_timer()

func _on_spawn_timer_timeout() -> void:
	var ufo = ufo_scene.instantiate() as Ufo
	ufo.global_position = position
	ufo.ufo_destroyed.connect(on_ufo_destroyed)
	get_tree().root.add_child(ufo)

func on_ufo_destroyed(points: int):
	ufo_destroyed_spawn.emit(points)
