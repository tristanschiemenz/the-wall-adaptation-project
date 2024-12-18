extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var is_being_picked_up = false
var animation_finisedV = false

func _ready() -> void:
	animated_sprite_2d.play("default")


func _on_mouse_entered() -> void:
	print("entered")
	is_being_picked_up = true

func _on_mouse_exited() -> void:
	print("entered")
	is_being_picked_up = false
	
func _on_animated_sprite_2d_animation_finished() -> void:
	animation_finisedV = true
