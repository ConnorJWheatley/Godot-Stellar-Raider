extends Area2D

class_name Player

signal life_lost(new_life_count: int)

var MAX_SPEED = 80
var speed : int
var direction: Vector2
const LEFT_BARRIER = -167
const RIGHT_BARRIER = 167

@onready var health_component := $HealthComponent
@onready var animated_sprite = $AnimatedSprite
@onready var player_sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	animated_sprite.visible = false
	speed = MAX_SPEED

func _physics_process(delta: float) -> void:
	var input = Input.get_axis("left", "right")
	if input < 0:
		direction = Vector2.LEFT
	elif input > 0:
		direction = Vector2.RIGHT
	else:
		direction = Vector2.ZERO

	var delta_movement = speed * direction.x * delta
	if (position.x + delta_movement <= LEFT_BARRIER || position.x + delta_movement >= RIGHT_BARRIER):
		return
	
	position.x += delta_movement

func on_player_destroyed():
	speed = 0
	player_sprite.visible = false
	animated_sprite.visible = true
	animated_sprite.play("player_death")
	health_component.damage() # removes one life

	## I know this code is better elsewhere but this is a tiny project
	# stop raider movement and shooting
	var raider_spawner_time = get_parent().get_node("RaiderSpawner").get_node("MovementTimer") as Timer
	raider_spawner_time.paused = true
	var raider_laser_spawner = get_parent().get_node("RaiderSpawner").get_node("LaserTimer") as Timer
	raider_laser_spawner.paused = true
	
	# stop ufo movement and shooting
	var ufo = get_tree().get_root().get_node_or_null("Ufo") as Ufo
	if ufo != null: # checking in case there is a UFO on screen when hit
		(ufo.get_node("LaserPoint").get_node("SpawnTimer") as Timer).paused = true
		ufo.speed = 0
		
	var ufo_spawn_timer = get_parent().get_node("UfoSpawner").get_node("SpawnTimer") as Timer
	ufo_spawn_timer.paused = true
	
	# time for death animation
	await get_tree().create_timer(3).timeout
		
	if health_component.lives == 0:
		get_tree().change_scene_to_file("res://scenes/menus/game_over_menu.tscn")
	else:
		# emit new life count to UI
		life_lost.emit(health_component.lives)
		
		# set player back to start position
		position.x = -167
		animated_sprite.play("respawn")
		
		# time for player respawn animation
		await get_tree().create_timer(2).timeout#
		
		player_sprite.visible = true
		animated_sprite.visible = false
		speed = MAX_SPEED
		
		# restart enemy behaviour
		raider_spawner_time.paused = false
		raider_laser_spawner.paused = false
		ufo_spawn_timer.paused = false
		if ufo != null:
			ufo.speed = 75
			(ufo.get_node("LaserPoint").get_node("SpawnTimer") as Timer).paused = false
