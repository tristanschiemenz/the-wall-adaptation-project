extends Path2D


# Path to the enemy scene
@export var enemy_scene: PackedScene
@export var spawn_interval: float = 10  # Time between enemy spawns

var spawn_timer: float = 0  # Internal timer

func _process(delta):
	# Update the spawn timer
	spawn_timer -= delta
	if spawn_timer <= 0:
		spawn_enemy()
		spawn_timer = spawn_interval  # Reset the timer
		if spawn_interval > 0.5:
			spawn_interval = spawn_interval / 2
	

func spawn_enemy():
	if not enemy_scene:
		print("Enemy scene not assigned!")
		return

	# Instance a new enemy
	var enemy = enemy_scene.instantiate()

	# Add the enemy to the same parent as the Path2D
	get_parent().add_child(enemy)

	# Create a temporary PathFollow2D node to find a random position along the path
	var path_follow = PathFollow2D.new()
	add_child(path_follow)  # Add it temporarily to the Path2D
	path_follow.progress_ratio = randf() * curve.get_baked_length()

	# Set the enemy's position based on the PathFollow2D node
	enemy.position = path_follow.position

	# Remove the temporary PathFollow2D node
	path_follow.queue_free()

	print("Enemy spawned at position:", enemy.position)
