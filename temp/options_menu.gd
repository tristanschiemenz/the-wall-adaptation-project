extends Control
@onready var label: Label = $VBoxContainer/Label

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")


func _on_h_slider_value_changed(value: float) -> void:
	label.text = "Volume: " + str(value)
