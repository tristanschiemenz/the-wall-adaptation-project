extends Control

func _on_exit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")
