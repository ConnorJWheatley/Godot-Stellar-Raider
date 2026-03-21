extends Control

func _on_play_again_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_back_to_menu_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
