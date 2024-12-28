extends Node2D
@onready var water: Area2D = $water

func _on_water_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://scenes/underwater.tscn")
