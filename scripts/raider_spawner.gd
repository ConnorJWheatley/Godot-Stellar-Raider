extends Node2D

class_name RaiderSpawner

signal raider_destroyed(points: int)

# spawner configuration
const ROWS: int = 6
const COLS: int = 6
const HORIZONTAL_SPACING: int = 8
const VERTICAL_SPACING: int = 8
const RAIDER_HEIGHT: int = 11
const RAIDER_WIDTH: int = 10
const RAIDERS_POSITION_X_INCREMENT: int = 10
const RAIDERS_POSITION_Y_INCREMENT: int = 15

var raider_scene = preload("res://scenes/raider.tscn")
var raider_laser = preload("res://scenes/raider_laser.tscn")

var start_y_pos: int = -25
var direction: int = 1

var raider_destroyed_count: int = 0
var raider_total_count: int = ROWS * COLS
var raider_level: int = 1

# configs for all raiders
var raider_1_res: Resource
var raider_2_res: Resource
var raider_3_res: Resource
var raider_4_res: Resource
var raider_5_res: Resource
var raider_6_res: Resource

# node references
@onready var movement_timer: Timer = $MovementTimer
@onready var laser_timer: Timer = $LaserTimer

var MOVE_TIMER_DEFAULT: float = 0.75

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# setup timers
	movement_timer.timeout.connect(move_raiders)
	laser_timer.timeout.connect(on_raider_shoot)
	
	# set configs for all raiders
	raider_1_res = preload("res://resources/raider_1.tres")
	raider_2_res = preload("res://resources/raider_2.tres")
	raider_3_res = preload("res://resources/raider_3.tres")
	raider_4_res = preload("res://resources/raider_4.tres")
	raider_5_res = preload("res://resources/raider_5.tres")
	raider_6_res = preload("res://resources/raider_6.tres")
	
	# needs to be called on start up for first level
	spawn_all_raiders(raider_level)
			
func spawn_all_raiders(level: int):
	# loads each raider and its properties
	var raider_config
	if level > 1:
		global_position = Vector2(0, -65)
		global_position.y += 8 * (level - 1)
	
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
			var y = start_y_pos + (row * RAIDER_HEIGHT) + (row * VERTICAL_SPACING)
			var spawn_pos = Vector2(x, y)
			
			spawn_raider(raider_config, spawn_pos)
	
	# reset timers
	reset_timers()

func spawn_raider(raider_config, spawn_pos: Vector2):
	var raider = raider_scene.instantiate() as Raider
	raider.config = raider_config
	raider.global_position = spawn_pos
	raider.raider_destroyed.connect(on_raider_destroyed)
	add_child.call_deferred(raider)
	
func move_raiders():
	position.x += RAIDERS_POSITION_X_INCREMENT * direction
	
func _on_right_wall_area_entered(_area: Area2D) -> void:
	if (direction == 1):
		position.y += RAIDERS_POSITION_Y_INCREMENT
		direction *= -1

func _on_left_wall_area_entered(_area: Area2D) -> void:
	if (direction == -1):
		position.y += RAIDERS_POSITION_Y_INCREMENT
		direction *= -1

func on_raider_shoot():
	var random_raider_position = get_children().filter(func (child): return child is Raider).map(func (raider): return raider.global_position).pick_random()
	var laser = raider_laser.instantiate() as RaiderLaser
	laser.global_position = random_raider_position
	get_tree().root.add_child(laser)

func on_raider_destroyed(points: int):
	raider_destroyed.emit(points)
	raider_destroyed_count += 1
	
	var level_multipler = ((raider_level - 1) * 36)
	
	if raider_destroyed_count == 15 + level_multipler:
		movement_timer.wait_time -= 0.15
	if raider_destroyed_count == 29 + level_multipler:
		movement_timer.wait_time -= 0.15
	if raider_destroyed_count == 32 + level_multipler:
		movement_timer.wait_time -= 0.15
	if raider_destroyed_count == 33 + level_multipler:
		movement_timer.wait_time -= 0.15
	if raider_destroyed_count == 35 + level_multipler:
		movement_timer.wait_time -= 0.1
	
	if raider_level == 10:
		# game will end automatically as raiders reach bottom zone, so this would be the win of all wins
		pass
	
	if raider_destroyed_count == raider_total_count * raider_level:
		start_new_level()
		
func start_new_level():
	laser_timer.stop()
	movement_timer.stop()
	
	# increase "level" and restart game whilst keeping intact scores and lives
	raider_level += 1
	
	# set direction back to 1 so raiders move to the right at the start
	direction = 1
	
	spawn_all_raiders(raider_level)
	
	# emit signal to player to move back to start position
	# wait a certain amount of time and then unpause timers
	
func reset_timers() -> void:
	laser_timer.start()
	movement_timer.start(MOVE_TIMER_DEFAULT)

func _on_bottom_wall_area_entered(_area: Area2D) -> void:
	get_tree().change_scene_to_file("res://scenes/menus/game_over_menu.tscn")
