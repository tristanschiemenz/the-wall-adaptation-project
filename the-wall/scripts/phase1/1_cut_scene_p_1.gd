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
var kev_speed = 100.0
var captain_speed = 100.0

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
	textbox_instance.show_textbox("Captain", "Welcome on the Wall newone. What was your name again? ... Ah Kavanagh I remeber.", 6.0,Vector2(10,550),false)
	
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
		await get_tree().process()
func first_stop():
	var textbox_instance = textbox_scene.instantiate()
	add_child(textbox_instance)
	
	textbox_instance.show_textbox("Captain","I believe you know your task. If not, I'll repeat it. You must shot everything you see in the water, because they are the others.",99999.0,Vector2(50, 550))
	
	await wait_for_enter()
	
	textbox_instance.show_textbox(
		"Captain", "Therefore, there's only one rule. Dont let the others come through if you let them through you will get put to sea.",10.0,Vector2(50, 550))

	await get_tree().create_timer(10.0).timeout
	start_kevin_walk()
	start_captain_walk()
	
func second_stop():
	var textbox_instance = textbox_scene.instantiate()
	add_child(textbox_instance)
	
	textbox_instance.show_textbox("Captain","Be carefull sometimes the light doesent function as excepted and break down but we fix it soon after it.",10.0,Vector2(1150, 550))
	
	await get_tree().create_timer(10.0).timeout
	
	textbox_instance.show_textbox(
		"Captain", "I will leave now you need to stay on the Wall for the next 100 days. In a 12h shift system but you will not have much free time so concentrate on the wall.",15.0,Vector2(1150, 550))

	await get_tree().create_timer(15.0).timeout
	
	textbox_instance.show_textbox(
		"Captain", "It might get boring. See you soon!",5.0,Vector2(1150, 550))
		
	await get_tree().create_timer(5.0).timeout
	captain_sprite.flip_h = true
	start_kevin_walk()
	start_captain_walk()

func last_stop():
	var fade_intstance = fade_out.instantiate()
	add_child(fade_intstance)
	fade_intstance.fade_in_black_with_text("First day on the Wall",8.0)
	await get_tree().create_timer(15.0).timeout
	fade_intstance.queue_free()
	queue_free()
	emit_signal("cutscene_finished")
# Public methods:
func start_kevin_walk(): 
	is_kev_moving = true

func stop_kevin_walk():
	is_kev_moving = false

func start_captain_walk():
	is_captain_moving = true

func stop_captain_walk():
	is_captain_moving = false
