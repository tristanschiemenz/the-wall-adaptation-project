extends Area2D
@onready var underwater: Node2D = $"../.."

func _on_body_entered(body: Node2D) -> void:
	underwater.add_point()
	queue_free()
