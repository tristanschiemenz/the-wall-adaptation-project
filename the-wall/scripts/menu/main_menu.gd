extends Control

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/phase1/1_cutscene_p_1.tscn")

func _on_options_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/options_menu.tscn")

func _on_exit_button_pressed() -> void:
	for action in InputMap.get_actions():
		print("Action: ", action)
		var events = InputMap.action_get_events(action)
		for event in events:
			print("  Event: ", event.as_text())
	get_tree().quit()
