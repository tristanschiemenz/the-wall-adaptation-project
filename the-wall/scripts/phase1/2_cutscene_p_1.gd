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

# We’ll track whether we've triggered certain stops
var hifa_stopped_once = false
var kev_stopped_once  = false

# For convenience, we can signal when the entire cutscene is done
signal cutscene_finished

func _ready():
	# 1) Calculate each path’s length (in pixels)
	#    (Make sure your HifaPath and KevPath have valid curves!)
	hifa_path_length = hifa_path.curve.get_baked_length()
	kev_path_length  = kev_path.curve.get_baked_length()
	
	# 2) Reset each path follower to the start
	hifa_path_follower.progress_ratio = 0.0
	kev_path_follower.progress_ratio  = 0.0

	# 3) Disable rotation if you don’t want the sprites to turn
	hifa_path_follower.rotates = false
	kev_path_follower.rotates  = false
	
	set_kev_start_position(Vector2(1600,779))
	start_hifa_walk()
	start_kev_walk()


func _process(delta: float) -> void:
	if is_hifa_moving:
		# If HifaSprite is an AnimatedSprite2D or AnimationPlayer, you can trigger the walk animation here
		hifa_sprite.play("walk")

		var increment_hifa = (hifa_speed / hifa_path_length) * delta
		hifa_path_follower.progress_ratio += increment_hifa

		# 1) Check if she reached the end (~1.0)
		if hifa_path_follower.progress_ratio >= 1.0:
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
#   Example: Setting Kev’s start and destination positions on the path
# -----------------------------------------------------------------------
#

# If KevPath has exactly one point (the destination), we can *add* a new start point.
# You can call this function from outside right after instantiating this scene,
# or from _ready() if you have the start position ready immediately.
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
func calculate_time(text):
	var words = len(text.split())
	return words / 10.0

func first_stop() -> void:
	# Example: show a series of textboxes or do something else
	var textbox_instance = textbox_scene.instantiate()
	add_child(textbox_instance)

	textbox_instance.show_textbox("Hifa", "Ugh, my hands are frozen solid. Feels like the wind’s always finding new ways to slice through you.", calculate_time("Ugh, my hands are frozen solid. Feels like the wind’s always finding new ways to slice through you."), Vector2(1120, 520), false)
	await get_tree().create_timer(calculate_time("Ugh, my hands are frozen solid. Feels like the wind’s always finding new ways to slice through you.")).timeout

	textbox_instance.show_textbox("Kavanagh", "Here, stand in front of me. I might block a bit of the gust.", calculate_time("Here, stand in front of me. I might block a bit of the gust."), Vector2(630, 520), true)
	await get_tree().create_timer(calculate_time("Here, stand in front of me. I might block a bit of the gust.")).timeout

	textbox_instance.show_textbox("Hifa", "Thanks. You’d think after all these months on the Wall we’d get used to the cold, but it still surprises me every time.", calculate_time("Thanks. You’d think after all these months on the Wall we’d get used to the cold, but it still surprises me every time."), Vector2(1120, 520), false)
	await get_tree().create_timer(calculate_time("Thanks. You’d think after all these months on the Wall we’d get used to the cold, but it still surprises me every time.")).timeout

	textbox_instance.show_textbox("Kavanagh", "It does. Some people say the chill seeps in deeper the longer you stay. I’m not sure if they mean just the weather or everything else going on around us.", calculate_time("It does. Some people say the chill seeps in deeper the longer you stay. I’m not sure if they mean just the weather or everything else going on around us."), Vector2(630, 520), true)
	await get_tree().create_timer(calculate_time("It does. Some people say the chill seeps in deeper the longer you stay. I’m not sure if they mean just the weather or everything else going on around us.")).timeout

	textbox_instance.show_textbox("Hifa", "Probably both. The waiting… the scanning the horizon for Others… it’s wearing.", calculate_time("Probably both. The waiting… the scanning the horizon for Others… it’s wearing."), Vector2(1120, 520), false)
	await get_tree().create_timer(calculate_time("Probably both. The waiting… the scanning the horizon for Others… it’s wearing.")).timeout

	textbox_instance.show_textbox("Kavanagh", "You ever think about what would happen if we—by accident—let someone through?", calculate_time("You ever think about what would happen if we—by accident—let someone through?"), Vector2(630, 520), true)
	await get_tree().create_timer(calculate_time("You ever think about what would happen if we—by accident—let someone through?")).timeout

	textbox_instance.show_textbox("Hifa", "I think about it all the time. We all do. If we fail… we become Others ourselves. Exiled to the sea.", calculate_time("I think about it all the time. We all do. If we fail… we become Others ourselves. Exiled to the sea."), Vector2(1120, 520), false)
	await get_tree().create_timer(calculate_time("I think about it all the time. We all do. If we fail… we become Others ourselves. Exiled to the sea.")).timeout

	textbox_instance.show_textbox("Kavanagh", "And that’s the end, basically. No chance of a future, of a normal life…", calculate_time("And that’s the end, basically. No chance of a future, of a normal life…"), Vector2(630, 520), true)
	await get_tree().create_timer(calculate_time("And that’s the end, basically. No chance of a future, of a normal life…")).timeout

	textbox_instance.show_textbox("Hifa", "But what if letting someone through wasn’t an accident? What if we did it—because it was the right thing to do?", calculate_time("But what if letting someone through wasn’t an accident? What if we did it—because it was the right thing to do?"), Vector2(1120, 520), false)
	await get_tree().create_timer(calculate_time("But what if letting someone through wasn’t an accident? What if we did it—because it was the right thing to do?")).timeout

	textbox_instance.show_textbox("Kavanagh", "I’m not even sure I know what the “right thing” is anymore. Saving your own life? Or saving someone else’s?", calculate_time("I’m not even sure I know what the “right thing” is anymore. Saving your own life? Or saving someone else’s?"), Vector2(630, 520), true)
	await get_tree().create_timer(calculate_time("I’m not even sure I know what the “right thing” is anymore. Saving your own life? Or saving someone else’s?")).timeout

	# Add the remaining dialogue similarly
	# "Hifa" and "Kavanagh" alternating with their text and calculated display times.

	# Example for ending
	textbox_instance.show_textbox("Hifa", "I think it could. If we can make it through this, if we don’t get exiled, and if we can stand all the changes after the Wall… I’d like to find out.", calculate_time("I think it could. If we can make it through this, if we don’t get exiled, and if we can stand all the changes after the Wall… I’d like to find out."), Vector2(1120, 520), false)
	await get_tree().create_timer(calculate_time("I think it could. If we can make it through this, if we don’t get exiled, and if we can stand all the changes after the Wall… I’d like to find out.")).timeout

	# Done: now we can continue walking
	start_hifa_walk()

func last_stop() -> void:
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
