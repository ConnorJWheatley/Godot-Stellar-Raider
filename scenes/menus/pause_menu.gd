extends Control

func _on_resume_btn_pressed() -> void:
	get_tree().paused = false
	hide()

func _on_quit_to_main_menu_btn_pressed() -> void:
	_on_resume_btn_pressed()
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")

func _on_restart_btn_pressed() -> void:
	_on_resume_btn_pressed()
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_options_btn_pressed() -> void:
	pass # Replace with function body.
