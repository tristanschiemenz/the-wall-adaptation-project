extends Node2D
@onready var dialog: Control = $player_p2/Camera2D/DialogPlayer
@onready var player: CharacterBody2D = $player_p2
@onready var down_border: CollisionShape2D = $borders/down_border
@onready var quest_dealer: Sprite2D = $fishing_quest_dealer/Sprite2D
@onready var fade_out = preload("res://scenes/fade_layer.tscn")

func _ready() -> void:
	pass
	
func _wait_for_accept() -> void:
	while true:
		if Input.is_action_just_pressed("ui_accept"):
			return

		await get_tree().process_frame

func _on_fishing_quest_dealer_body_entered(body: Node2D) -> void:
	if !QuestStatus.quest_given:
		_give_quest_dialog()
		QuestStatus.quest_given = true
	
	if !QuestStatus.quest_finished:
		return
		
	_quest_finished_dialog()
		
func _give_quest_dialog() -> void:
	player.can_move = false
	quest_dealer.flip_h = true
	
	dialog.display_text("???","Hey, you there! The new one.")
	await _wait_for_accept()
	await get_tree().create_timer(.5).timeout
	
	dialog.display_text("Kavanagh", "Me?")
	await _wait_for_accept()
	await get_tree().create_timer(.5).timeout
	
	dialog.display_text("???", "Yeah, you. I've got a task for you.")
	await _wait_for_accept()
	await get_tree().create_timer(.5).timeout

	dialog.display_text("Kavanagh", "A task?")
	await _wait_for_accept()
	await get_tree().create_timer(.5).timeout

	dialog.display_text("???", "Listen, food's running low around here, as you'll soon find out.")
	await _wait_for_accept()
	await get_tree().create_timer(.5).timeout
	
	dialog.display_text("???", "Your job is simple: dive into the waters off the south edge of the rafts and search for food. Shellfish, seaweed, anything edible.")
	await _wait_for_accept()
	await get_tree().create_timer(.5).timeout

	dialog.display_text("???", "Bring whatever you find back to me. Understand?")
	await _wait_for_accept()
	await get_tree().create_timer(.5).timeout

	dialog.display_text("Kavanagh", "Okay. I'll do it.")
	await _wait_for_accept()
	await get_tree().create_timer(.5).timeout

	dialog.display_text("???", "Good. Don't come back empty-handed.")
	await _wait_for_accept()
	await get_tree().create_timer(.5).timeout
	
	player.can_move = true
	dialog.hide()
	down_border.disabled = true

func _quest_finished_dialog():
	player.can_move = false
	quest_dealer.flip_h = true
	
	dialog.display_text("Kavanagh", "Here's the food I managed to gather.")
	await _wait_for_accept()
	await get_tree().create_timer(.5).timeout

	dialog.display_text("???", "Thank you. This will help us more than you know.")
	await _wait_for_accept()
	await get_tree().create_timer(.5).timeout

	dialog.display_text("Kavanagh", "I didn't catch your name. Who are you?")
	await _wait_for_accept()
	await get_tree().create_timer(.5).timeout

	dialog.display_text("Kellan", "Oh, right. I'm Kellan. Sorry, it's been a long day for all of us.")
	await _wait_for_accept()
	await get_tree().create_timer(.5).timeout

	dialog.display_text("Kavanagh", "Nice to meet you, Kellan. I’m Kavanagh.")
	await _wait_for_accept()
	await get_tree().create_timer(.5).timeout

	dialog.display_text("Kellan", "Well, Kavanagh, you've done more than enough for today. Go find a place to sleep. You've earned it.")
	await _wait_for_accept()
	await get_tree().create_timer(.5).timeout

	dialog.display_text("Kavanagh", "Thanks. I guess I'll see you tomorrow.")
	await _wait_for_accept()
	await get_tree().create_timer(.5).timeout

	dialog.display_text("Kellan", "Tomorrow, yes... if tomorrow comes quietly.")
	await _wait_for_accept()
	await get_tree().create_timer(.5).timeout
	
	var fade_intstance = fade_out.instantiate()
	add_child(fade_intstance)
	fade_intstance.fade_in_black_with_text("A few weeks later",8.0)
	await get_tree().create_timer(10.0).timeout
	fade_intstance.queue_free()
	get_tree().change_scene_to_file("res://scenes/phase2/theisland_cutscene.tscn")

func _on_water_dive_area_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://scenes/phase2/diving_game.tscn")
