extends RigidBody2D

@export var speed: float = 50  # Speed of the enemy's downward movement
@onready var explosion = $explosion_sprite
@onready var boat = $boat_sprite
@onready var explosion_audio = $explosion_audio
@onready var scream_audio = $scream_audio
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position.y += speed * delta

	# Remove the enemy if it moves off-screen (you can adjust this logic as needed)
	if position.y > get_viewport_rect().size.y+100:
		queue_free()

var rng = RandomNumberGenerator.new()
func _on_enemy_area_area_entered(area: Area2D) -> void:
	var enemy_node = area.get_parent() # Assuming area is a child of the enemy node
	if area.name == "BulletArea":
		# bullet
		enemy_node.queue_free()
		
		# enemy
		explosion.show()
		boat.hide()
		speed = 0
		explosion.play("boom")
		explosion_audio.play()
		if rng.randi_range(0, 100) < 30:
			scream_audio.play()
		await get_tree().create_timer(1).timeout
		explosion.hide()
		await get_tree().create_timer(3).timeout
		
		queue_free()
	elif area.name == "WallArea":
		explosion.show()
		boat.hide()
		speed = 0
		explosion.play("boom")
		explosion_audio.play()
		await get_tree().create_timer(1.5).timeout
		queue_free()
	queue_free()
