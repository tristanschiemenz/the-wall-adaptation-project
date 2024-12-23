extends RigidBody2D

@export var speed: float = 50  # Speed of the enemy's downward movement

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position.y += speed * delta

	# Remove the enemy if it moves off-screen (you can adjust this logic as needed)
	if position.y > get_viewport_rect().size.y+100:
		queue_free()


func _on_enemy_area_area_entered(area: Area2D) -> void:
	var enemy_node = area.get_parent() # Assuming area is a child of the enemy node
	if area.name == "BulletArea":
		# Remove the enemy
		enemy_node.queue_free()
		
		# Remove the bullet
		queue_free()
	if area.name == "WallArea":
		queue_free()
	queue_free()
