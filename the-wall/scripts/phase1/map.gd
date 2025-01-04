extends TileMapLayer



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rain_rect = $RainRect
	rain_rect.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
var rng = RandomNumberGenerator.new()
func _on_flicker_timer_timeout() -> void:
	rng.randomize()
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


func _on_rain_timer_timeout() -> void:
	# 1) Decide if we show the RainRect
	var rand_num = rng.randi_range(0, 100)
	if rand_num < 20:
		$RainRect.show()

		# 2) Create a one-shot timer with random time between 15-30 seconds
		var random_duration = rng.randf_range(20.0, 40.0)
		var hide_timer = Timer.new()
		hide_timer.one_shot = true
		hide_timer.wait_time = random_duration
		
		# 3) Connect the timer’s timeout to a function that hides RainRect
		hide_timer.timeout.connect(
		Callable(self, "_on_hide_timer_timeout").bind(hide_timer))
		
		# Add and start the timer
		add_child(hide_timer)
		hide_timer.start()

func _on_hide_timer_timeout(timer: Timer) -> void:
	$RainRect.hide()
	timer.queue_free()


func _on_fly_by_timer_timeout() -> void:
	var rand_num = rng.randi_range(0, 100)
	if rand_num < 50:
		$fly_by_audio.play()


func _on_ambient_noise_finished() -> void:
	$ambient_noise.play(0)
