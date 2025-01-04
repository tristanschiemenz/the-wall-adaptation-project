extends Area2D
@onready var diving_game: Node2D = $"../.."



func _on_body_entered(body: Node2D) -> void:
	diving_game.add_point()
	queue_free()
