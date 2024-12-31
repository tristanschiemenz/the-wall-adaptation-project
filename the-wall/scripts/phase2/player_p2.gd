extends CharacterBody2D
const SPEED = 300.0

func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO  # Reset velocity each frame

	# Get input direction
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("right"):
		velocity.x += 1

	# Normalize velocity to maintain consistent speed in all directions
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
	if velocity.x != 0 or velocity.y != 0:
		$AnimatedSprite2D.play()
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		$AnimatedSprite2D.stop()
	# Move the player
	move_and_slide()
