extends Node2D

#
# --- Multiple @onready references for each entity ---
#
@onready var textbox_scene = preload("res://scenes/text_box.tscn")
@onready var fade_out = preload("res://scenes/fade_layer.tscn")

@onready var KevPath = $KevPath
@onready var KevPathFollower = $KevPath/KevPathFollower
@onready var KevSprite = $KevPath/KevPathFollower/KevSprite

@onready var HifaPath = $HifaPath
@onready var HifaPathFollower = $HifaPath/HifaPathFollower
@onready var HifaSprite = $HifaPath/HifaPathFollower/HifaSprite

@onready var CaptainPath = $CaptainPath
@onready var CaptainPathFollower = $CaptainPath/CaptainPathFollower
@onready var CaptainSprite = $CaptainPath/CaptainPathFollower/CaptainSprite

@onready var OtherPath = $OtherPath
@onready var OtherPathFollower = $OtherPath/OtherPathFollower
@onready var OtherSprite = $OtherPath/OtherPathFollower/OtherSprite

@onready var BoatPath = $BoatPath
@onready var BoatPathFollower = $BoatPath/BoatPathFollower
@onready var BoatSprite = $BoatPath/BoatPathFollower/BoatSprite

@onready var Boat2Path = $Boat2Path
@onready var Boat2PathFollower = $Boat2Path/BoatPathFollower
@onready var Boat2Sprite = $Boat2Path/Boat2PathFollower/Boat2Sprite

@onready var Boat3Path = $Boat3Path
@onready var Boat3PathFollower = $Boat3Path/BoatPathFollower
@onready var Boat3Sprite = $Boat3Path/BoatPathFollower/BoatSprite

@onready var Boat4Path = $Boat4Path
@onready var Boat4PathFollower = $Boat4Path/BoatPathFollower
@onready var Boat4Sprite = $Boat4Path/BoatPathFollower/BoatSprite

@onready var BulletPath = $BulletPath
@onready var BulletPathFollower = $BulletPath/BulletPathFollower
@onready var BulletSprite = $BulletPath/BulletPathFollower/BulletSprite

@onready var Bullet2Path = $Bullet2Path
@onready var Bullet2PathFollower = $Bullet2Path/BulletPathFollower
@onready var Bullet2Sprite = $Bullet2Path/BulletPathFollower/BulletSprite

signal cutscene_finished

var steps_playing = false
#
# Called when this node is added to the scene
#
func _ready():
	#start_timeline()
	reset_all_progress()
	BulletSprite.hide()
	Bullet2Sprite.hide()

#
#1) Reset progress_ratio to 0.0 for each follower
#
func reset_all_progress():
	HifaPathFollower.progress_ratio = 0.0
	CaptainPathFollower.progress_ratio = 0.0
	OtherPathFollower.progress_ratio = 0.0
	BoatPathFollower.progress_ratio = 0.0
	Boat2PathFollower.progress_ratio = 0.0
	Boat3PathFollower.progress_ratio = 0.0
	Boat4PathFollower.progress_ratio = 0.0
func set_kev_start_position(start_pos: Vector2):
	var curve = KevPath.curve
	#Check if the path currently has just one point (the end).
	if curve.get_point_count() == 1:
		#Insert the start as the first point, and keep the existing end as the second point.
		var end_pos = curve.get_point_position(0)
		curve.clear_points()
		curve.add_point(start_pos)
		curve.add_point(end_pos)

		# Decide which way Kev should face
		if start_pos.x < end_pos.x:
			KevSprite.flip_h = false  # face right
		else:
			KevSprite.flip_h = true   # face left
	start_timeline()

#
# 2) Main timeline in a coroutine style
#
func start_timeline() -> void:
	KevSprite.play("walk")
	await move_path_to_end(KevPathFollower, 100.0)
	KevSprite.stop()
	# a) All boats move to the end at 100 speed
	await move_boats_to_end(100.0)

	await speech1()  # <--- call the first textbox/dialogue function

	# c) Hifa moves at speed 200, then calls speech2
	HifaSprite.flip_h = true
	HifaSprite.play("walk")
	await move_path_to_end(HifaPathFollower, 200.0)
	HifaSprite.stop()
	await speech2()  # <--- call the second textbox/dialogue function

	CaptainSprite.flip_h = true
	CaptainSprite.play("walk")
	OtherSprite.play("walk")
	await move_multiple_to_end([
		{"follower": OtherPathFollower, "speed": 100.0},
		{"follower": CaptainPathFollower, "speed": 100.0}
	])
	CaptainSprite.stop()
	OtherSprite.stop()
	await speech3()  # <--- call the third textbox/dialogue function
	
	# Done with timeline
	print("Timeline finished!")

#
# ---------------------------------------------------------------------------
#   Movement helper functions
# ---------------------------------------------------------------------------
#

# Move a single PathFollower from ratio 0.0 up to 1.0 at the given speed
func move_path_to_end(follower, speed) -> void:
	var path2d = follower.get_parent() as Path2D
	var path_length = path2d.curve.get_baked_length()
	follower.progress_ratio = 0.0
	
	while follower.progress_ratio < 1.0:
		if steps_playing == false:
			$FootSteps.play()
			steps_playing = true 
		var delta = get_process_delta_time()
		var increment = (speed / path_length) * delta
		follower.progress_ratio += increment
		if follower.progress_ratio >= 0.99:
			follower.progress_ratio = 1.0
		await get_tree().process_frame

# Move all 4 boats in parallel until they reach ratio 1.0
func move_boats_to_end(speed: float) -> void:
	BoatPathFollower.progress_ratio  = 0.0
	Boat2PathFollower.progress_ratio = 0.0
	Boat3PathFollower.progress_ratio = 0.0
	Boat4PathFollower.progress_ratio = 0.0

	var path_length1 = (BoatPath as Path2D).curve.get_baked_length()
	var path_length2 = (Boat2Path as Path2D).curve.get_baked_length()
	var path_length3 = (Boat3Path as Path2D).curve.get_baked_length()
	var path_length4 = (Boat4Path as Path2D).curve.get_baked_length()
	
	while true:
		var delta = get_process_delta_time()
		# Boat1
		if BoatPathFollower.progress_ratio < 1.0:
			BoatPathFollower.progress_ratio += (speed / path_length1) * delta
			if BoatPathFollower.progress_ratio > 0.99:
				BoatPathFollower.progress_ratio = 1.0
		
		# Boat2
		if Boat2PathFollower.progress_ratio < 1.0:
			Boat2PathFollower.progress_ratio += (speed / path_length2) * delta
			if Boat2PathFollower.progress_ratio > 0.99:
				Boat2PathFollower.progress_ratio = 1.0
		
		# Boat3
		if Boat3PathFollower.progress_ratio < 1.0:
			Boat3PathFollower.progress_ratio += (speed / path_length3) * delta
			if Boat3PathFollower.progress_ratio > 0.99:
				Boat3PathFollower.progress_ratio = 1.0
		
		# Boat4
		if Boat4PathFollower.progress_ratio < 1.0:
			Boat4PathFollower.progress_ratio += (speed / path_length4) * delta
			if Boat4PathFollower.progress_ratio > 0.99:
				Boat4PathFollower.progress_ratio = 1.0
		
		# Check if all done
		if (BoatPathFollower.progress_ratio  >= 0.99
		 and Boat2PathFollower.progress_ratio >= 0.99
		 and Boat3PathFollower.progress_ratio >= 0.99
		 and Boat4PathFollower.progress_ratio >= 0.99):
			break

		await get_tree().process_frame

# Move multiple followers in parallel (each entry in 'entities' is {follower, speed})
func move_multiple_to_end(entities: Array) -> void:
	# Initialize them at ratio 0
	for ent in entities:
		var f = ent.follower as PathFollow2D
		f.progress_ratio = 0.0
	
	# Capture path lengths
	var path_lengths = []
	for ent in entities:
		var follower = ent.follower as PathFollow2D
		var path2d = follower.get_parent() as Path2D
		path_lengths.append(path2d.curve.get_baked_length())
	
	while true:
		if steps_playing == false:
			$FootSteps.play()
			steps_playing = true 
		var delta = get_process_delta_time()
		var all_done = true
		
		for i in range(entities.size()):
			var follower = entities[i].follower as PathFollow2D
			var speed = entities[i].speed as float
			var length = path_lengths[i] as float

			if follower.progress_ratio < 1.0:
				all_done = false
				follower.progress_ratio += (speed / length) * delta
				if follower.progress_ratio >= 0.99:
					follower.progress_ratio = 1.0
		
		if all_done:
			break
		
		await get_tree().process_frame

#
# ---------------------------------------------------------------------------
#   Empty functions for dialogues (or textboxes)
# ---------------------------------------------------------------------------
#
func wait_for_enter() -> void:
	# This will block until the user presses "ui_accept" (Enter/Space by default).
	while true:
		if Input.is_action_just_pressed("ui_accept"):
			return
		# Wait until next frame so we don't freeze the game
		await get_tree().process_frame
func speech1():
	var textbox_instance = textbox_scene.instantiate()
	add_child(textbox_instance)

	await textbox_instance.show_textbox("Kavanagh", "They're everywhere... there are too many of them. We can't hold them off!", 99999.0, Vector2(250, 680), true)
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout
	
	textbox_instance.queue_free()


func speech2():
	KevSprite.flip_h = false
	HifaSprite.flip_h = false
	var textbox_instance = textbox_scene.instantiate()
	add_child(textbox_instance)
	
	await textbox_instance.show_textbox("Hifa", "Kavanagh! The Others have hit the eastern ramp - multiple defenders down. And... the Captain... he - he turned on us. He killed our own men!", 99999.0, Vector2(710, 630), false)
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout

	await textbox_instance.show_textbox("Kavanagh", "What? That can't be - why would he do that?", 99999.0, Vector2(250, 680), true)
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout
	
	textbox_instance.queue_free()

func shoot_cap_other() -> void:
	BulletSprite.show()
	Bullet2Sprite.show()
	
	var path_length1 = (BulletPath as Path2D).curve.get_baked_length()
	var path_length2 = (Bullet2Path as Path2D).curve.get_baked_length()
	var speed = 300

	# Start from zero if needed:
	BulletPathFollower.progress_ratio = 0.0
	Bullet2PathFollower.progress_ratio = 0.0

	while true:
		var delta = get_process_delta_time()

		# Move first bullet
		if BulletPathFollower.progress_ratio < 1.0:
			BulletPathFollower.progress_ratio += (speed / path_length1) * delta
			if BulletPathFollower.progress_ratio >= 0.99:
				BulletPathFollower.progress_ratio = 1.0
				CaptainSprite.rotation_degrees = 45
				BulletSprite.hide()

		# Move second bullet
		if Bullet2PathFollower.progress_ratio < 1.0:
			Bullet2PathFollower.progress_ratio += (speed / path_length2) * delta
			if Bullet2PathFollower.progress_ratio >= 0.99:
				Bullet2PathFollower.progress_ratio = 1.0
				OtherSprite.rotation_degrees = 45
				Bullet2Sprite.hide()

		# If both bullets are at or past the end, break
		if BulletPathFollower.progress_ratio >= 1.0 and Bullet2PathFollower.progress_ratio >= 1.0:
			break

		# Yield so we don't block the thread (important!)
		await get_tree().process_frame

	# Now that the loop is done, do the rest:
	CaptainSprite.rotation_degrees = 45
	OtherSprite.rotation_degrees = 45

	BulletSprite.hide()
	Bullet2Sprite.hide()

func speech3():
	var textbox_instance = textbox_scene.instantiate()
	add_child(textbox_instance)
	
	await textbox_instance.show_textbox("Captain", "The breach was successful. Almost all the attackers made it over the wall, and some are already in the cars.", 99999.0, Vector2(1310, 590), false)
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout

	await textbox_instance.show_textbox("The Other", "Thank you very much for your service. The community will help you if you get caught.", 99999.0, Vector2(1330, 660), false)
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout
	
	await textbox_instance.show_textbox("Captain", "Almost all of the defenders are down. Who will come to get me?", 99999.0, Vector2(1310, 590), false)
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout
	
	await textbox_instance.show_textbox("Hifa", "You betrayed us. We trusted you, and you just let so many others in.", 99999.0, Vector2(710, 630), false)
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout
	
	await textbox_instance.show_textbox("Captain", "What will you do now, Hifa? There are too many of us for just the two of you.", 99999.0,Vector2(1310, 590), false)
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout
	
	await textbox_instance.show_textbox("Kavanagh", "HIFA shoot them.", 99999.0, Vector2(250, 680), true)
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout
	
	await shoot_cap_other()
	
	await textbox_instance.show_textbox("Kavanagh", "They're through the Wall... we failed. We'll be sent to sea for letting them in.", 99999.0, Vector2(250, 680), true)
	await wait_for_enter()
	await get_tree().create_timer(.5).timeout
	
	textbox_instance.queue_free()
	
	var fade_intstance = fade_out.instantiate()
	add_child(fade_intstance)
	fade_intstance.fade_in_black_with_text("We will get send to sea",8.0)
	await get_tree().create_timer(10.0).timeout
	emit_signal("cutscene_finished")
	get_tree().change_scene_to_file("res://scenes/phase2/cutscene_boat.tscn")


func _on_foot_steps_finished() -> void:
	steps_playing = false
