extends Node2D

#
# --- Node references ---
#
@onready var captain_path        = $CaptainPath
@onready var captain_path_follower= $CaptainPath/CaptainPathFollower
@onready var captain_sprite         = $CaptainPath/CaptainPathFollower/CaptainSprite

@onready var kev_path            = $KevPath
@onready var kev_path_follower   = $KevPath/KevPathFollower
@onready var kev_sprite          = $KevPath/KevPathFollower/KevSprite

#
# --- Preloaded scenes/scripts (for text boxes, fade layers, etc.) ---
#
@onready var textbox_scene = preload("res://scenes/text_box.tscn")
@onready var fade_out = preload("res://scenes/fade_layer.tscn")

#
# --- Movement speeds and path lengths ---
#
var captain_speed = 100.0
var kev_speed  = 100.0

var captain_path_length = 0.0
var kev_path_length  = 0.0

# Whether characters are currently walking
var is_captain_moving = false
var is_kev_moving  = false

# We'll track whether we've triggered certain stops
var captain_stopped_once = false
var kev_stopped_once  = false

# For convenience, we can signal when the entire cutscene is done
signal cutscene_finished

func _ready():
	# 1) Calculate each path's length (in pixels)
	#    (Make sure your captainPath and KevPath have valid curves!)
	captain_path_length = captain_path.curve.get_baked_length()
	kev_path_length  = kev_path.curve.get_baked_length()
	
	# 2) Reset each path follower to the start
	captain_path_follower.progress_ratio = 0.0
	kev_path_follower.progress_ratio  = 0.0

	# 3) Disable rotation if you don't want the sprites to turn
	captain_path_follower.rotates = false
	kev_path_follower.rotates  = false
	
	start_captain_walk()
	start_kev_walk()
	


func _process(delta: float) -> void:
	if is_captain_moving:
		# If captainSprite is an AnimatedSprite2D or AnimationPlayer, you can trigger the walk animation here
		captain_sprite.play("walk")

		var increment_captain = (captain_speed / captain_path_length) * delta
		captain_path_follower.progress_ratio += increment_captain

		# 1) Check if she reached the end (~1.0)
		if captain_path_follower.progress_ratio >= 0.99:
			captain_path_follower.progress_ratio = 1.0
			stop_captain_walk()
			last_stop()
			# Possibly do something like last_stop_captain()
		
		if not captain_stopped_once and abs(captain_path_follower.progress_ratio - 0.4612) < 0.001:
			stop_captain_walk()
			captain_stopped_once = true
			first_stop()

	else:
		captain_sprite.stop() 
		pass


	if is_kev_moving:
		kev_sprite.play("walk")
		var increment_kev = (kev_speed / kev_path_length) * delta
		kev_path_follower.progress_ratio += increment_kev

		# 1) Check if Kev reached the end
		if kev_path_follower.progress_ratio >= 0.99:
			kev_path_follower.progress_ratio = 1.0
			kev_sprite.flip_h = true
			stop_kev_walk()
		
	else:
		kev_sprite.stop()
		pass

#
# -----------------------------------------------------------------------
#   Example: Setting Kev's start and destination positions on the path
# -----------------------------------------------------------------------
#

func set_kev_start_position(start_pos: Vector2):
	var curve = kev_path.curve
	
	# Check if the path currently has just one point (the end).
	if curve.get_point_count() == 1:
		# Insert the start as the first point, and keep the existing end as the second point.
		var end_pos = curve.get_point_position(0)
		curve.clear_points()
		curve.add_point(start_pos)
		curve.add_point(end_pos)

		# Decide which way Kev should face
		if start_pos.x < end_pos.x:
			kev_sprite.flip_h = false  # face right
		else:
			kev_sprite.flip_h = true   # face left
	
	# After modifying the curve, recalc the length and reset Kev to the start
	kev_path_length = kev_path.curve.get_baked_length()
	kev_path_follower.progress_ratio = 0.0

#
# -----------------------------------------------------------------------
#   Stop and resume logic for captain
# -----------------------------------------------------------------------
#
func wait_for_enter() -> void:
	# This will block until the user presses "ui_accept" (Enter/Space by default).
	while true:
		if Input.is_action_just_pressed("ui_accept"):
			return
		# Wait until next frame so we don't freeze the game
		await get_tree().process_frame

func first_stop() -> void:
	# Example: show a series of textboxes or do something else
	var textbox_instance = textbox_scene.instantiate()
	add_child(textbox_instance)

	await textbox_instance.show_textbox("Captain", "Kavanagh, how's the watch so far? Heard you're nearing the end of your first year.", 99999.0, Vector2(550, 600), true)
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout

	await textbox_instance.show_textbox("Kavanagh", "Steady enough, sir. The shifts have been quiet lately... though it doesn't feel like a year has gone by.", 99999.0, Vector2(1000, 550), false)
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout

	await textbox_instance.show_textbox("Captain", "Time has a way of creeping up on you out here. Don't let your guard down, though. You still have another year to go.", 99999.0, Vector2(550, 600), true)
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout

	await textbox_instance.show_textbox("Kavanagh", "I understand, sir. I'll stay focused - no matter how long it takes.", 99999.0, Vector2(1000, 550), false)
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout

	await textbox_instance.show_textbox("Captain", "Good man. Keep it tight. We can't afford to lose anyone else.", 99999.0, Vector2(550, 600), true)
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout
	
	


	# Done: now we can continue walking
	start_captain_walk()

func last_stop() -> void:
	var fade_intstance = fade_out.instantiate()
	add_child(fade_intstance)
	fade_intstance.fade_in_black_with_text("I want to get off the Wall",8.0)
	await get_tree().create_timer(10.0).timeout
	emit_signal("cutscene_finished")


# -----------------------------------------------------------------------
#   Public methods to start/stop each character
# -----------------------------------------------------------------------
#

func start_captain_walk():
	is_captain_moving = true

func stop_captain_walk():
	is_captain_moving = false

func start_kev_walk():
	is_kev_moving = true

func stop_kev_walk():
	is_kev_moving = false
