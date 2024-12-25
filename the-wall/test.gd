extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var scene1 = preload("res://scenes/phase1/1_cutscene_p_1.tscn").instantiate()
	add_child(scene1)
	scene1.cutscene_finished.connect(_on_cutscene_finished)
func _on_cutscene_finished():
	var scene2 = preload("res://scenes/phase1/game_p_1.tscn").instantiate()
	
	add_child(scene2)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
