extends Area2D

class_name Player

var speed = 80
var direction: Vector2
const LEFT_BARRIER = -167
const RIGHT_BARRIER = 167
@onready var player_death_sprite = $AnimatedSprite2D
@onready var player_sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	player_death_sprite.visible = false

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
	player_death_sprite.visible = true
	player_death_sprite.play("player_death")
	
	# check player lives count
	# if 0, end game. 
		# send to screen to give a 3 letter name and save score
	# otherwise
		# player starts back at beginning position
		# enemies stay in their same position
		# probably send signal to game scene, seems like good place to handle this logic
	
	
