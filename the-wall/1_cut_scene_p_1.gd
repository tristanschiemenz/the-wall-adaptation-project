extends Node2D

@onready var kev_path = $KevPath
@onready var kev_path_follower = $KevPath/KevPathFollower
@onready var kev_sprite = $KevPath/KevPathFollower/Kev
@onready var captain_path = $CaptainPath
@onready var captain_path_follower = $CaptainPath/CaptainPathFollower
@onready var captain_sprite = $CaptainPath/CaptainPathFollower/Captain

# Actual speeds in pixels per second:
var kev_speed = 100.0
var captain_speed = 100.0

var kev_path_length = 0.0
var captain_path_length = 0.0

var is_kev_moving = false
var is_captain_moving = false

func _ready():
	# Get the actual pixel length of each path
	kev_path_length = kev_path.curve.get_baked_length()
	captain_path_length = captain_path.curve.get_baked_length()

	# Reset progress to the start
	kev_path_follower.progress_ratio = 0.0
	captain_path_follower.progress_ratio = 0.0

	# Turn off rotation if desired
	kev_path_follower.rotates = false
	captain_path_follower.rotates = false

	# Optionally start them walking
	start_kevin_walk()
	start_captain_walk()

func _process(delta):
	if is_kev_moving:
		kev_sprite.animation = "walk"
		kev_sprite.play()
		# Advance Kevin's progress by the fraction of the path
		var increment = (kev_speed / kev_path_length) * delta
		kev_path_follower.progress_ratio += increment

		# Clamp if it goes beyond the end
		if kev_path_follower.progress_ratio >= 1.0:
			kev_path_follower.progress_ratio = 1.0
			is_kev_moving = false
		if abs(kev_path_follower.progress_ratio - 0.3738) < 0.002:
			stop_kevin_walk()
	else:
		kev_sprite.stop()
	if is_captain_moving:
		captain_sprite.animation = "walk"
		captain_sprite.play()
		var increment = (captain_speed / captain_path_length) * delta
		captain_path_follower.progress_ratio += increment

		if captain_path_follower.progress_ratio >= 1.0:
			captain_path_follower.progress_ratio = 1.0
			is_captain_moving = false
		if abs(captain_path_follower.progress_ratio - 0.167) < 0.002:
			print("hi")
			stop_captain_walk()
	else:
		captain_sprite.stop()
# Public methods:
func start_kevin_walk():
	is_kev_moving = true

func stop_kevin_walk():
	is_kev_moving = false

func start_captain_walk():
	is_captain_moving = true

func stop_captain_walk():
	is_captain_moving = false
