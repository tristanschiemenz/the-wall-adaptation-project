extends Node2D
@onready var dialog: Control = $DialogPlayer
@onready var fade_out_animation: AnimationPlayer = $fadeOutAnimation

func _wait_for_accept() -> void:
	while true:
		if Input.is_action_just_pressed("ui_accept"):
			return

		await get_tree().process_frame


func _ready() -> void:
	await get_tree().process_frame
	_ending_dialog()
	
	
func _ending_dialog() -> void:
	dialog.display_text("Kavanagh", "We've been drifting for a while now, and there's still no land in sight.")
	await _wait_for_accept()
	await get_tree().create_timer(0.5).timeout

	dialog.display_text("Hifa", "Yes, you're right.")
	await _wait_for_accept()
	await get_tree().create_timer(0.5).timeout
	
	dialog.display_text("Hifa", "... I have to tell you something.")
	await _wait_for_accept()
	await get_tree().create_timer(0.5).timeout

	dialog.display_text("Hifa", "I didn't actually want to breed. It was more about wanting sex... and getting off the Wall.")
	await _wait_for_accept()
	await get_tree().create_timer(0.5).timeout

	dialog.display_text("Kavanagh", "I kno-")
	await _wait_for_accept()
	await get_tree().create_timer(0.5).timeout

	dialog.display_text("Kavanagh", "Wait! Can you see that? In the distance, it looks like some kind of oil platform.")
	await _wait_for_accept()
	await get_tree().create_timer(0.5).timeout

	dialog.display_text("Hifa", "You're right! We might be saved.")
	await _wait_for_accept()
	await get_tree().create_timer(0.5).timeout

	dialog.display_text("Kavanagh", "It'll still take some time to reach it just by floating, but we can paddle to speed things up.")
	await _wait_for_accept()
	await get_tree().create_timer(0.5).timeout

	dialog.display_text("Hifa", "If we have to wait, then tell me a story.")
	await _wait_for_accept()
	await get_tree().create_timer(0.5).timeout

	dialog.display_text("Kavanagh", "A story? I can't think of one right now. Or... wait, maybe I know one.")
	await _wait_for_accept()
	await get_tree().create_timer(0.5).timeout
	
	dialog.display_text("Kavanagh", "It would begin like this...")
	await _wait_for_accept()
	await get_tree().create_timer(0.5).timeout
	
	dialog.display_text("Kavanagh", "It's cold on the Wall...")
	await _wait_for_accept()
	await get_tree().create_timer(0.5).timeout
	
	fade_out_animation.play("fadeout")

	
