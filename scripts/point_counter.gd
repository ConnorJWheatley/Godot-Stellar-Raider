extends Node

class_name PointCounter

signal on_points_increased(points: int)
var points = 0

@onready var raider_spwaner = $"../RaiderSpawner" as RaiderSpawner
@onready var ufo_spawner = $"../UfoSpawner" as UfoSpawner

func _ready() -> void:
	raider_spwaner.raider_destroyed.connect(increase_points)
	ufo_spawner.ufo_destroyed_spawn.connect(increase_points)
	
func increase_points(points_to_add: int):
	points += points_to_add
	on_points_increased.emit(points)
