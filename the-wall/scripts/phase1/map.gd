extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
var rng = RandomNumberGenerator.new()
func _on_flicker_timer_timeout() -> void:
	var rand_num = rng.randi_range(0,1)
	if rand_num == 0:
		if $left_light.energy != 1:
			$left_light.energy = 1
		else:
			$left_light.energy = rng.randf_range(0,1)
	if rand_num == 1:
		if $right_light.energy != 1:
			$right_light.energy = 1
		else:
			$right_light.energy = rng.randf_range(0,1)
