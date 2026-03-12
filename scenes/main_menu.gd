extends Control

func _on_start_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_option_btn_pressed() -> void:
	pass # Replace with function body.

func _on_exit_btn_pressed() -> void:
	get_tree().quit()
