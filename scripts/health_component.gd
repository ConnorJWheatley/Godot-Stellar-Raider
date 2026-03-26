extends Node2D

class_name HealthComponent

@export var MAX_LIVES := 10
var lives : int

func _ready():
	lives = MAX_LIVES

func damage():
	lives -= 1
