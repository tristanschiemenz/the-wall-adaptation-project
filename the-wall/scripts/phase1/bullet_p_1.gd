extends RigidBody2D


var velocity: Vector2 = Vector2(0, -400)  # Moves upward by default

@onready var audio = $AudioStreamPlayer2D

func _ready() -> void:
	audio.play()

func _process(delta):
	# Move the bullet based on its velocity
	position += velocity * delta

	# Check if the bullet is off-screen
	if position.y < -500:
		queue_free()  # Remove the bullet to prevent memory lea
