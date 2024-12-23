extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Load the universal textbox scene
	var textbox_scene = preload("res://scenes/text_box.tscn")
	
	# Create an instance of it
	var textbox_instance = textbox_scene.instantiate()
	
	# Add it as a child to the current node (or another node of your choice)
	add_child(textbox_instance)
	
	# Finally, call its custom function to show text
	textbox_instance.show_textbox("My Header", "My Body Text", 5.0,Vector2(500,500))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
