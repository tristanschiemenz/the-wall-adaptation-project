extends Control

func _on_play_pressed() -> void:
	#get_tree().change_scene_to_file("res://path_to_your_game_scene.tscn")
	pass

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/options_menu.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
