extends Node2D

#
# --- Node references ---
#
@onready var hifa_path           = $HifaPath
@onready var hifa_path_follower  = $HifaPath/HifaPathFollower
@onready var hifa_sprite         = $HifaPath/HifaPathFollower/HifaSprite

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
var hifa_speed = 100.0
var kev_speed  = 100.0

var hifa_path_length = 0.0
var kev_path_length  = 0.0

# Whether characters are currently walking
var is_hifa_moving = false
var is_kev_moving  = false

# We'll track whether we've triggered certain stops
var hifa_stopped_once = false
var kev_stopped_once  = false

# For convenience, we can signal when the entire cutscene is done
signal cutscene_finished

func _ready():
	# 1) Calculate each path's length (in pixels)
	#    (Make sure your HifaPath and KevPath have valid curves!)
	hifa_path_length = hifa_path.curve.get_baked_length()
	kev_path_length  = kev_path.curve.get_baked_length()
	
	# 2) Reset each path follower to the start
	hifa_path_follower.progress_ratio = 0.0
	kev_path_follower.progress_ratio  = 0.0

	# 3) Disable rotation if you don't want the sprites to turn
	hifa_path_follower.rotates = false
	kev_path_follower.rotates  = false
	
	start_hifa_walk()
	start_kev_walk()


func _process(delta: float) -> void:
	if is_hifa_moving:
		# If HifaSprite is an AnimatedSprite2D or AnimationPlayer, you can trigger the walk animation here
		hifa_sprite.play("walk")

		var increment_hifa = (hifa_speed / hifa_path_length) * delta
		hifa_path_follower.progress_ratio += increment_hifa

		# 1) Check if she reached the end (~1.0)
		if hifa_path_follower.progress_ratio >= 0.99:
			hifa_path_follower.progress_ratio = 1.0
			stop_hifa_walk()
			last_stop()
			# Possibly do something like last_stop_hifa()
		
		if not hifa_stopped_once and abs(hifa_path_follower.progress_ratio - 0.4435) < 0.001:
			stop_hifa_walk()
			hifa_stopped_once = true
			first_stop()

	else:
		hifa_sprite.stop() 
		pass


	if is_kev_moving:
		kev_sprite.play("walk")
		var increment_kev = (kev_speed / kev_path_length) * delta
		kev_path_follower.progress_ratio += increment_kev

		# 1) Check if Kev reached the end
		if kev_path_follower.progress_ratio >= 0.99:
			kev_path_follower.progress_ratio = 1.0
			kev_sprite.flip_h = false
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
#   Stop and resume logic for Hifa
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

	await textbox_instance.show_textbox("Hifa", "Ugh, my hands are frozen solid. Feels like the wind's always finding new ways to slice through you.", 99999.0, Vector2(1120, 520), false)
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout

	await textbox_instance.show_textbox("Kavanagh", "Here, stand in front of me. I might block a bit of the gust.", 99999.0, Vector2(630, 520), true)
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout

	await textbox_instance.show_textbox("Hifa", "Thanks. You'd think after all these months on the Wall we'd get used to the cold, but it still surprises me every time.", 99999.0, Vector2(1120, 520), false)
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout

	await textbox_instance.show_textbox("Kavanagh", "It does. Some people say the chill seeps in deeper the longer you stay. I'm not sure if they mean just the weather or everything else going on around us.", 99999.0, Vector2(630, 520), true)
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout

	await textbox_instance.show_textbox("Hifa", "Probably both. The waiting... the scanning the horizon for Others... it's wearing.", 99999.0, Vector2(1120, 520), false)
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout

	await textbox_instance.show_textbox("Kavanagh", "You ever think about what would happen if we, by accident, let someone through?", 99999.0, Vector2(630, 520), true)
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout

	await textbox_instance.show_textbox("Hifa", "I think about it all the time. We all do. If we fail... we become Others ourselves. Exiled to the sea.", 99999.0, Vector2(1120, 520), false)
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout

	await textbox_instance.show_textbox("Kavanagh", "And that's the end, basically. No chance of a future, of a normal life...", 99999.0, Vector2(630, 520), true)
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout

	await textbox_instance.show_textbox("Hifa", "I know the official line: If you let them through, you're condemning the whole country, betraying everyone inside these walls. But sometimes I wonder - maybe we aren't really safe in here anyway.", 99999.0, Vector2(1120, 520), false)
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout

	await textbox_instance.show_textbox("Kavanagh", "In the end, it's just fear that keeps us in line...", 99999.0, Vector2(630, 520), true)
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout

	await textbox_instance.show_textbox("Hifa", "I've never had anyone to talk to about these doubts. Maybe it's because I haven't found anyone I really... trust.", 99999.0, Vector2(1120, 520), false)
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout

	await textbox_instance.show_textbox("Kavanagh", "You can trust me, Hifa. I know we haven't spent much time together, but... I like hearing what you actually think. No one wants to voice these questions out loud.", 99999.0, Vector2(630, 520), true)
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout

	await textbox_instance.show_textbox("Hifa", "I think I like hearing your voice more than I should.", 99999.0, Vector2(1120, 520), false)
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout

	await textbox_instance.show_textbox("Kavanagh", "Maybe we're both looking for someone to share this burden with.", 99999.0, Vector2(630, 520), true)
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout

	await textbox_instance.show_textbox("Hifa", "Do you ever picture a life after these two years on the Wall? Where you're not scanning the horizon or freezing out here?", 99999.0, Vector2(1120, 520), false)
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout

	await textbox_instance.show_textbox("Kavanagh", "I do. But it always feels like I'm jinxing it. Like if I think too much about life after, I'll lose focus here and - ", 99999.0, Vector2(630, 520), true)
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout

	await textbox_instance.show_textbox("Hifa", " - and slip up, and let the Others in.", 99999.0, Vector2(1120, 520), false)
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout

	await textbox_instance.show_textbox("Kavanagh", "Exactly. But if we survive the full term, then we get to choose, right? Some people go into security, others... become 'Breeders.'", 99999.0, Vector2(630, 520), true)
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout

	await textbox_instance.show_textbox("Hifa", "Yes, 'Breeders.' I hate that word. But it's the path for most of us who want a future - some sense of family.", 99999.0, Vector2(1120, 520), false)
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout

	await textbox_instance.show_textbox("Kavanagh", "I never thought much about having children before. It felt like the world was so... broken.", 99999.0, Vector2(630, 520), true)
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout

	await textbox_instance.show_textbox("Hifa", "And now?", 99999.0, Vector2(1120, 520), false)
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout

	await textbox_instance.show_textbox("Kavanagh", "Maybe... there's a chance to fix things if enough of us start caring again. If we choose to love instead of fear.", 99999.0, Vector2(630, 520), true)
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout
	
	await textbox_instance.show_textbox("Hifa", "And if we can find someone to care about, maybe having children won't feel like bringing them into a nightmare.", 99999.0, Vector2(1120, 520), false)
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout

	await textbox_instance.show_textbox("Kavanagh", "Hifa... do you think that someone could be... us?", 99999.0, Vector2(630, 520), true)
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout

	await textbox_instance.show_textbox("Hifa", "I think it could. If we can make it through this, if we don't get exiled, and if we can stand all the changes after the Wall... I'd like to find out.", 99999.0, Vector2(1120, 520), false)
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout

	await textbox_instance.show_textbox("Kavanagh", "I promise I'll watch out for you, Hifa. And one day - when we're off this Wall - we'll decide together what comes next.", 99999.0, Vector2(630, 520), true)
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout

	await textbox_instance.show_textbox("Hifa", "One day. Until then, we keep each other safe.", 99999.0, Vector2(1120, 520), false)
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout
	textbox_instance.queue_free()


	# Done: now we can continue walking
	start_hifa_walk()

func last_stop() -> void:
	var fade_intstance = fade_out.instantiate()
	add_child(fade_intstance)
	fade_intstance.fade_in_black_with_text("I think I love Hifa",8.0)
	await get_tree().create_timer(10.0).timeout
	emit_signal("cutscene_finished")


# -----------------------------------------------------------------------
#   Public methods to start/stop each character
# -----------------------------------------------------------------------
#

func start_hifa_walk():
	is_hifa_moving = true

func stop_hifa_walk():
	is_hifa_moving = false

func start_kev_walk():
	is_kev_moving = true

func stop_kev_walk():
	is_kev_moving = false
