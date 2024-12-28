extends CharacterBody2D
@onready var sprite_2d: Sprite2D = $Sprite2D

const SPEED = 100.0

func _physics_process(delta: float) -> void:
	var direction_x := Input.get_axis("move_left", "move_right")
	var direction_y := Input.get_axis("move_up", "move_down")
	
	# Horizontaler Flip basierend auf horizontaler Bewegung
	if direction_x > 0:
		sprite_2d.flip_h = false
	elif direction_x < 0:
		sprite_2d.flip_h = true
	
	# Bewegung in X-Richtung
	if direction_x:
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Bewegung in Y-Richtung
	if direction_y:
		velocity.y = direction_y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	move_and_slide()
