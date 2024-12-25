extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect
@onready var label: Label = $Label

func _ready():
	# Ensure the ColorRect is invisible at the start if you want to begin transparent
	color_rect.modulate.a = 0.0
	label.visible = false

# Fade in the black screen with optional text.
func fade_in_black_with_text(text_to_show: String, fade_duration: float = 2.0):
	# Set up the text
	label.text = text_to_show
	label.visible = true
	
	# Create a tween
	var tween = get_tree().create_tween()
	# Animate the alpha of color_rect from 0.0 to 1.0
	tween.tween_property(color_rect, "modulate:a", 1.0, fade_duration)
	
	# Optionally, call a function when finished
	tween.tween_callback(Callable(self, "_on_fade_in_complete"))

func _on_fade_in_complete():
	# This is called once the fade is fully black
	# You could trigger another scene load, show a button, etc.
	pass

func fade_out_black(fade_duration: float = 2.0):
	# Fade from black (1.0) back to transparent (0.0)
	var tween = get_tree().create_tween()
	tween.tween_property(color_rect, "modulate:a", 0.0, fade_duration)
	tween.tween_callback(Callable(self, "_on_fade_out_complete"))

func _on_fade_out_complete():
	# Once fade-out is complete, you can hide the label
	label.visible = false
