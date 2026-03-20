extends Node2D

class_name Game

@onready var pause_menu = $PauseMenu
var pause_toggle = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause_menu.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.d
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		print("I HAVE BEEN PRESSED")
		toggle_pause()

func toggle_pause():
	pause_toggle = !pause_toggle
	get_tree().paused = pause_toggle
	pause_menu.visible = pause_toggle
