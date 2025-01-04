extends AnimationPlayer

func _wait_for_accept() -> void:
	pause()
	while true:
		if Input.is_action_just_pressed("ui_accept"):
			play()
			return

		await get_tree().process_frame
