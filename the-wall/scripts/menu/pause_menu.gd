extends Control
@onready var game: Node2D = $".."

func _on_continue_button_pressed() -> void:
	game.toggle_pause_menu()
	
	
func _on_options_button_pressed() -> void:
	pass # Replace with function body.


func _on_exit_button_pressed() -> void:
	get_tree().quit()
