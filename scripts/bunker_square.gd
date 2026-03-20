extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.area_entered.connect(_on_area_entered)

func _on_area_entered(area):
	if area is Laser || RaiderLaser || Raider:
		area.queue_free()
		queue_free()
