extends CanvasLayer

var life_texture = preload("res://graphics/player/player_ship.png")

@onready var points_label: Label = $ScoreElements/Points
@onready var points_counter = $"../PointCounter" as PointCounter
@onready var life_counter = $"ScoreElements/Lives" as Label
@onready var raider_spawner = $"../RaiderSpawner" as RaiderSpawner

func _ready() -> void:
	life_counter.visible = false
	points_counter.on_points_increased.connect(points_increased)
	raider_spawner.game_won.connect(on_game_won)
	raider_spawner.game_lost.connect(on_game_lost)
	get_parent().get_node("Player").life_lost.connect(_update_life_count)
	
func points_increased(points):
	var points_str  = str(points)
	var str_length = points_str.length()
	if str_length == 2:
		points_str = "00" + points_str
		points_label.text = points_str
	if str_length == 3:
		points_str = "0" + points_str
		points_label.text = points_str
	if str_length == 4:
		points_label.text = points_str

func _update_life_count(new_life_count: int) -> void:
	life_counter.text = str(new_life_count)
	for i in range(5):
		life_counter.visible = true
		await get_tree().create_timer(0.25).timeout
		life_counter.visible = false
		await get_tree().create_timer(0.25).timeout

func on_game_won():
	pass
	
func on_game_lost():
	pass
