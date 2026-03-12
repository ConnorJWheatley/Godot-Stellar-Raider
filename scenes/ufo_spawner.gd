extends Node2D

@onready var spawn_timer: Timer = $SpawnTimer
var ufo_scene: PackedScene = preload("res://scenes/ufo.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_timer.setup_timer()

func _on_spawn_timer_timeout() -> void:
	var ufo = ufo_scene.instantiate()
	ufo.global_position = position
	get_tree().root.add_child(ufo)
