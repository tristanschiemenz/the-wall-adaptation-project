extends Node2D

@onready var spawn_path_follower = $Map_P1/SpawnPath/SpawnPathFollower
@onready var overlay = $Overlay_P1/DayLabel

var enemy_scene = preload("res://scenes/phase1/enemy_p_1.tscn")

# Current day in the simulation
var current_day: int = 1

# We'll dynamically create these timers in _ready()
var day_timer: Timer
var enemy_timer: Timer

# How often (in seconds) to spawn an enemy
var enemy_spawn_interval: float = 1.0

# A random number generator for enemy spawning and more
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	
	spawn_path_follower.rotates = false
	
	# -------------------------------
	# 1) Create a Timer for day progression
	# -------------------------------
	day_timer = Timer.new()
	day_timer.one_shot = false #repeat the spawn timer
	day_timer.timeout.connect(_on_day_timer_timeout)
	add_child(day_timer)

	#day label
	overlay.text = "Day: " + str(current_day)
	
	#day speed
	set_day_timer_wait_time()
 
	day_timer.start()

	# -------------------------------
	# 5) Create another Timer for enemy spawning
	# -------------------------------
	enemy_timer = Timer.new()
	enemy_timer.one_shot = false
	enemy_timer.wait_time = enemy_spawn_interval
	enemy_timer.timeout.connect(_on_enemy_timer_timeout)
	add_child(enemy_timer)
	enemy_timer.start()

# -------------------------------------------------------------------
# DAY TIMER CALLBACK
# -------------------------------------------------------------------
func _on_day_timer_timeout() -> void:
	# Once we hit day 100, we can optionally stop the timer (or do something else).
	if current_day >= 100:
		day_timer.stop()
		#cutscene and phase switch
		return
	
	current_day += 1
	overlay.text = "Day: " + str(current_day)
	#cutscene in between
	if current_day == 70:
		 # Pause the day progression
		run_cutscene_2()
	
	set_day_timer_wait_time()
func run_cutscene_2() -> void:
	day_timer.stop()
	enemy_timer.stop() 
	var cutscene_2_scene = preload("res://scenes/phase1/2_cutscene_p_1.tscn")
	var cutscene_2_instance = cutscene_2_scene.instantiate()
	
	# Pass in the player’s current position to the cutscene
	var kev_pos = $Player_P1.position
	$Player_P1.hide()
	$Player_P1.set_process(false)
	$Player_P1.set_physics_process(false)
	add_child(cutscene_2_instance)
	cutscene_2_instance.set_kev_start_position(Vector2(kev_pos))
	# Wait for the cutscene to emit its "cutscene_finished" signal
	await cutscene_2_instance.cutscene_finished
	
	# Once done, remove the cutscene from the scene tree
	cutscene_2_instance.queue_free()

	# Move player if needed
	$Player_P1.position = Vector2(1070, 713)

	# Resume normal game flow (day timer, etc.)
	$Player_P1.show()
	$Player_P1.set_process(true)
	$Player_P1.set_physics_process(true)
	set_day_timer_wait_time()
	day_timer.start()
	enemy_timer.start()
# -------------------------------------------------------------------
# ENEMY TIMER CALLBACK {every second}
# -------------------------------------------------------------------
func _on_enemy_timer_timeout() -> void:
	spawn_enemies_for_day(current_day)

# -------------------------------------------------------------------
# CHANGING THE DAY TIMER INTERVAL BASED ON DAY
# -------------------------------------------------------------------
func set_day_timer_wait_time() -> void:
	if current_day < 70:
		# From day 1 to day 69 => every 2 seconds
		day_timer.wait_time = 0.1
	elif current_day < 80:
		# From day 70 to 79 => every 10 seconds
		day_timer.wait_time = 10.0
	elif current_day < 90:
		# From day 80 to 89 => every 20 seconds
		day_timer.wait_time = 20.0
	else:
		# From day 90 to 99 => every 20 seconds again
		day_timer.wait_time = 20.0


# -------------------------------------------------------------------
# SPAWNING LOGIC BASED ON DAY
# -------------------------------------------------------------------
func spawn_enemies_for_day(day: int) -> void:
	if day < 70:
		if rng.randi_range(0, 100) < 5:
			spawn_enemy()
	elif day < 80:
		if rng.randi_range(0, 100) < 20:
			spawn_enemy()
	elif day < 90:
		if rng.randi_range(0, 100) < 30:
			spawn_enemy()
	elif day < 100:
		if rng.randi_range(0, 100) < 50:
			spawn_enemy()
	else:
		# If day >= 100, you could do something else or ignore.
		pass

# -------------------------------------------------------------------
# THE ACTUAL SPAWN
# -------------------------------------------------------------------
func spawn_enemy() -> void:
	# Place the path follower at a random ratio
	var rand_num = rng.randf_range(0, 1)
	spawn_path_follower.progress_ratio = rand_num

	# Instantiate the enemy scene
	var enemy_instance = enemy_scene.instantiate()
	add_child(enemy_instance)
	
	# Position it
	enemy_instance.global_position = spawn_path_follower.global_position
	
	# Give the enemy a random speed if your script uses it
	enemy_instance.speed = rng.randi_range(25, 100)
	print("Spawned enemy on day %d at ratio %.2f" % [current_day, rand_num])
