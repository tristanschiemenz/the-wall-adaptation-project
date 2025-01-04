extends Node2D
@onready var dialog: Control = $player_p2/DialogPlayer
@onready var theisland: Node2D = $"."
@onready var score_label: Label = $player_p2/Camera2D/score_label

var food_collected = 0
const MAX_SCORE = 10

func add_point():
	food_collected += 1
	
	score_label.text = "%d / %d food collected" % [food_collected, MAX_SCORE]
	
	if food_collected == MAX_SCORE:
		dialog.display_text("Kavanagh", "I think I’ve gathered enough. It’s time to head back up.")


func _on_dive_out_area_body_entered(body: Node2D) -> void:
	if food_collected != MAX_SCORE:
		dialog.display_text("Kavanagh", "This won’t be enough. I need to gather more if I want to make it.")
		return

	QuestStatus.quest_finished = true
	get_tree().change_scene_to_file("res://scenes/phase2/theisland_map.tscn")

func _on_dive_out_area_body_exited(body: Node2D) -> void:
	dialog.hide()
