extends Node2D

@onready var kev_path = $KevPath
@onready var kev_path_follower = $KevPath/KevPathFollower
@onready var kev_sprite = $KevPath/KevPathFollower/Kev
@onready var captain_path = $CaptainPath
@onready var captain_path_follower = $CaptainPath/CaptainPathFollower
@onready var captain_sprite = $CaptainPath/CaptainPathFollower/Captain
@onready var textbox_scene = preload("res://scenes/text_box.tscn")
@onready var fade_out = preload("res://scenes/fade_layer.tscn")
# Actual speeds in pixels per second:
var kev_speed = 70.0
var captain_speed = 70.0

signal cutscene_finished

var kev_path_length = 0.0
var captain_path_length = 0.0

var is_kev_moving = false
var is_captain_moving = false

var firstStop = false
var secondStop = false
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
	

	
	# Create an instance of it
	var textbox_instance = textbox_scene.instantiate()
	
	# Add it as a child to the current node (or another node of your choice)
	add_child(textbox_instance)
	
	# Finally, call its custom function to show text
	textbox_instance.show_textbox("Captain", "Kavanagh, welcome to the Wall. I'm the Captain, and I'm the one who decides who's worth trusting up here. You're new, so listen carefully.", 9.0,Vector2(10,550),false)
	
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
		if kev_path_follower.progress_ratio >= 0.99:
			stop_kevin_walk()
		if abs(kev_path_follower.progress_ratio - 0.3738) < 0.001 and firstStop == false:
			stop_kevin_walk()
			first_stop()
			firstStop = true
		if abs(kev_path_follower.progress_ratio - 0.979) < 0.001 and secondStop == false:
			stop_kevin_walk()
			
			
	else:
		kev_sprite.stop()
	if is_captain_moving:
		captain_sprite.animation = "walk"
		captain_sprite.play()
		var increment = (captain_speed / captain_path_length) * delta
		captain_path_follower.progress_ratio += increment

		if captain_path_follower.progress_ratio >= 0.99:
			stop_captain_walk()
			last_stop()
		if abs(captain_path_follower.progress_ratio - 0.167) < 0.001 and firstStop == false:
			stop_captain_walk()
		if abs(captain_path_follower.progress_ratio - 0.485) < 0.001 and secondStop == false:
			stop_captain_walk()
			second_stop()
			secondStop = true
	else:
		captain_sprite.stop()
		
		
func wait_for_enter() -> void:
	# This will block until the user presses "ui_accept" (Enter/Space by default).
	while true:
		if Input.is_action_just_pressed("ui_accept"):
			return
		# Wait until next frame so we don't freeze the game
		await get_tree().process_frame
func first_stop():
	var textbox_instance = textbox_scene.instantiate()
	add_child(textbox_instance)
	
	textbox_instance.show_textbox("Captain","This isn't just any posting - it's your life for the next two years. If you fail, you're gone. That's not just talk. It's the law of the Wall.",10.0,Vector2(50, 550))
	
	await get_tree().create_timer(10.0).timeout
	
	textbox_instance.show_textbox("Captain", "Now, about how you move and fight. Think of it as drilling: you press Enter whenever you want to advance to the next command - like you're listening for my orders, got it?",99999.0,Vector2(50, 550))

	await wait_for_enter()
	await get_tree().create_timer(.5).timeout
	
	textbox_instance.show_textbox("Captain", "Movement's your lifeline. Use W, A, S, D on your kit's interface - or if that's not comfortable, the arrow keys work just as well. Keep those feet moving, soldier.",99999.0,Vector2(50, 550))

	await wait_for_enter()
	await get_tree().create_timer(.5).timeout
	textbox_instance.queue_free()
	
	start_kevin_walk()
	start_captain_walk()
	
func second_stop():
	var textbox_instance = textbox_scene.instantiate()
	add_child(textbox_instance)
	
	textbox_instance.show_textbox("Captain","The Others won't wait for you to get cozy. When you see them, left-click to fire in their direction. Don't hesitate - one moment of doubt and they'll be over the Wall.",99999.0,Vector2(1150, 550))
	
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout
	
	textbox_instance.show_textbox("Captain", "You'll feel the recoil in your arms. That's normal. The adrenaline spike? That's also normal. Just keep your aim steady and your head on a swivel.",99999.0,Vector2(1150, 550))

	await wait_for_enter()
	await get_tree().create_timer(.5).timeout
	
	textbox_instance.show_textbox("Captain", "You're not just shooting at silhouettes - these are people who will do anything to get in. Our job is to make sure that doesn't happen. Clear?",99999.0,Vector2(1150, 550))
		
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout
	
	textbox_instance.show_textbox("Captain", "Keep your eyes forward, but never forget to check your corners. The sea's full of surprises, and the Others know how to use them to their advantage.",99999.0,Vector2(1150, 550))
		
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout
	
	textbox_instance.show_textbox("Captain", "Survive your shift, rest and repeat. Do it enough times without messing up, and maybe - just maybe - you'll outlast your tour on the Wall.",99999.0,Vector2(1150, 550))
		
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout
	
	textbox_instance.show_textbox("Captain", "That's all the wisdom you get for now, Kavanagh. Remember the controls, keep your fear in check, and watch for my orders. Welcome aboard. Now, let's see if you've got what it takes.",99999.0,Vector2(1150, 550))
		
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout
	
	textbox_instance.queue_free()
	
	captain_sprite.flip_h = true
	start_kevin_walk()
	start_captain_walk()

func last_stop():
	var fade_intstance = fade_out.instantiate()
	add_child(fade_intstance)
	fade_intstance.fade_in_black_with_text("First day on the Wall",8.0)
	await get_tree().create_timer(15.0).timeout
	fade_intstance.queue_free()
	get_tree().change_scene_to_file("res://scenes/phase1/game_p_1.tscn")
	#emit_signal("cutscene_finished")
# Public methods:
func start_kevin_walk(): 
	is_kev_moving = true

func stop_kevin_walk():
	is_kev_moving = false

func start_captain_walk():
	is_captain_moving = true

func stop_captain_walk():
	is_captain_moving = false
