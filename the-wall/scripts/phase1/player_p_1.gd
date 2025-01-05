extends CharacterBody2D


const SPEED = 300.0
@export var bullet_scene: PackedScene
@export var shoot_cooldown: float = 0.5

var can_shoot: bool = true
var shoot_timer: float = 0.5

var steps_playing: bool = false

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
		if steps_playing == false:
			$FootSteps.play()
			steps_playing = true
		$AnimatedSprite2D.play()
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		$AnimatedSprite2D.stop()
	# Move the player
	move_and_slide()

func shoot():

	# Load and instance the bullet scene
	var bullet = bullet_scene.instantiate()

	# Position the bullet at the player's position
	bullet.position = position


	# Add the bullet to the current scene
	get_parent().add_child(bullet)
	
	
func _process(delta: float) -> void:
	# Reduce the shoot timer over time
	if shoot_timer > 0:
		shoot_timer -= delta

	if (Input.is_action_pressed("shoot") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) and shoot_timer <= 0:
		shoot()
		shoot_timer = shoot_cooldown
		


func _on_foot_steps_finished() -> void:
	steps_playing = false
