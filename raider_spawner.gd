extends Node2D

class_name RaiderSpawner

signal raider_destroyed(points: int)
signal game_won
signal game_lost

# spawner configuration
const ROWS = 6
const COLS = 6
const HORIZONTAL_SPACING = 8
const VERTICAL_SPACING = 8
const RAIDER_HEIGHT = 11
const RAIDER_WIDTH = 10
const START_Y_POS = -25
const RAIDERS_POSITION_X_INCREMENT = 10
const RAIDERS_POSITION_Y_INCREMENT = 15

var direction = 1
var raider_scene = preload("res://scenes/raider.tscn")
var raider_laser = preload("res://scenes/raider_laser.tscn")
var y_increment_count = 0 # how many times the raiders move down the screen

var raider_destroyed_count = 0
var raider_total_count = ROWS * COLS

# node references
@onready var movement_timer = $MovementTimer
@onready var laser_timer: Timer = $LaserTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# setup timers
	movement_timer.timeout.connect(move_raiders)
	laser_timer.timeout.connect(on_raider_shoot)
	
	# loads each raider and its properties
	var raider_1_res = preload("res://resources/raider_1.tres")
	var raider_2_res = preload("res://resources/raider_2.tres")
	var raider_3_res = preload("res://resources/raider_3.tres")
	var raider_4_res = preload("res://resources/raider_4.tres")
	var raider_5_res = preload("res://resources/raider_5.tres")
	var raider_6_res = preload("res://resources/raider_6.tres")
	
	var raider_config
	
	for row in ROWS:
		if row == 0:
			raider_config = raider_6_res
		if row == 1:
			raider_config = raider_5_res
		if row == 2:
			raider_config = raider_4_res
		if row == 3:
			raider_config = raider_3_res
		if row == 4:
			raider_config = raider_2_res
		if row == 5:
			raider_config = raider_1_res
			
		var row_width = (COLS * RAIDER_WIDTH * 3) + ((COLS - 1) * HORIZONTAL_SPACING)
		var start_x = (position.x - row_width) / 1.375
		
		for col in COLS:
			var x = start_x + (col * RAIDER_WIDTH * 3) + (col * HORIZONTAL_SPACING)
			var y = START_Y_POS + (row * RAIDER_HEIGHT) + (row * VERTICAL_SPACING)
			var spawn_pos = Vector2(x, y)
			
			spawn_raider(raider_config, spawn_pos)
			
func _physics_process(_delta: float) -> void:
	# if the y_increment count reaches certain values, decrease the movement timer
	#f y_increment_count
	pass

func spawn_raider(raider_config, spawn_pos: Vector2):
	var raider = raider_scene.instantiate() as Raider
	raider.config = raider_config
	raider.global_position = spawn_pos
	raider.raider_destroyed.connect(on_raider_destroyed)
	add_child(raider)
	
func move_raiders():
	position.x += RAIDERS_POSITION_X_INCREMENT * direction
	
# each time it bounces, keep count so that after a certain amount of time I can decrease the timer to make the movement faster
func _on_right_wall_area_entered(_area: Area2D) -> void:
	if (direction == 1):
		position.y += RAIDERS_POSITION_Y_INCREMENT
		direction *= -1
		y_increment_count += 1

func _on_left_wall_area_entered(_area: Area2D) -> void:
	if (direction == -1):
		position.y += RAIDERS_POSITION_Y_INCREMENT
		direction *= -1
		y_increment_count += 1

func on_raider_shoot():
	var random_raider_position = get_children().filter(func (child): return child is Raider).map(func (raider): return raider.global_position).pick_random()
	var laser = raider_laser.instantiate() as RaiderLaser
	laser.global_position = random_raider_position
	get_tree().root.add_child(laser)

func on_raider_destroyed(points: int):
	raider_destroyed.emit(points)
	raider_destroyed_count += 1
	
	if raider_destroyed_count == raider_total_count:
		game_won.emit()
		laser_timer.stop()
		movement_timer.stop()

func _on_bottom_wall_area_entered(area: Area2D) -> void:
	get_tree().change_scene_to_file("res://scenes/menus/game_over_menu.tscn")
