extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var fade_out = preload("res://scenes/fade_layer.tscn")


func _ready() -> void:
	await get_tree().process_frame
	animation_player.play("main_animation")

func _cut_scene_finished():
	var fade_intstance = fade_out.instantiate()
	add_child(fade_intstance)
	fade_intstance.fade_in_black_with_text("Drifting into the vast ocean...",8.0)
	await get_tree().create_timer(10.0).timeout
	fade_intstance.queue_free()
	
	get_tree().change_scene_to_file("res://scenes/phase3/ending_scene.tscn")
