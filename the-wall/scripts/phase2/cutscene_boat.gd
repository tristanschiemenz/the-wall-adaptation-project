extends Node2D

@onready var dialog_player: Control = $Camera2D/DialogPlayer
@onready var main_animation_player: AnimationPlayer = $MainAnimationPlayer
@onready var fade_out = preload("res://scenes/fade_layer.tscn")


func _ready() -> void:
	await get_tree().process_frame
	main_animation_player.play("first_day_animation")

	
	
func next_day_fade() -> void:
	var fade_intstance = fade_out.instantiate()
	add_child(fade_intstance)
	fade_intstance.fade_in_black_with_text("The next day",8.0)
	await get_tree().create_timer(10.0).timeout
	fade_intstance.queue_free()
	main_animation_player.play("second_day_animation")
	
func next_night_fade() -> void:
	var fade_intstance = fade_out.instantiate()
	add_child(fade_intstance)
	fade_intstance.fade_in_black_with_text("The next night",8.0)
	await get_tree().create_timer(10.0).timeout
	fade_intstance.queue_free()
	main_animation_player.play("third_night_animation")
	
func island_skip_fade() -> void:
	var fade_intstance = fade_out.instantiate()
	add_child(fade_intstance)
	fade_intstance.fade_in_black_with_text("Arriving at the island \nin the south",8.0)
	await get_tree().create_timer(10.0).timeout
	fade_intstance.queue_free()
	get_tree().change_scene_to_file("res://scenes/phase2/theisland_map.tscn")
	
