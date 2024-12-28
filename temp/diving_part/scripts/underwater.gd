extends Node2D

@onready var score_label: Label = $player/Label
@onready var leave_area: Area2D = $leaveArea

var score: int = 0
const MAX_SCORE: int = 10

# Fügt einen Punkt hinzu und aktualisiert die Anzeige
func add_point() -> void:
	score += 1
	if score == MAX_SCORE:
		score_label.text = "You collected enough food! Leave!"
	else:
		score_label.text = "%d / %d food" % [score, MAX_SCORE]

# Event: Körper betritt den Verlass-Bereich
func _on_leave_area_body_entered(body: Node2D) -> void:
	if score == MAX_SCORE:
		get_tree().change_scene_to_file("res://scenes/node_2d.tscn")
	else:
		score_label.text = "You haven't collected enough food!"

# Event: Körper verlässt den Verlass-Bereich
func _on_leave_area_body_exited(body: Node2D) -> void:
	score_label.text = "%d / %d food" % [score, MAX_SCORE]
