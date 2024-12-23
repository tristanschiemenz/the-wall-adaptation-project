extends Control



@onready var header_label = $HeaderLabel
@onready var body_label   = $BodyLabel
@onready var timer        = $DisappearTimer

func _ready():
	# Connect the Timer timeout signal to our callback
	# (In Godot 4, we use the new syntax below)
	timer.timeout.connect(_on_disappear_timeout)
	
	# Initially hide the entire control
	hide()

func show_textbox(header_text: String, body_text: String, duration: float = 3.0, position: Vector2 = Vector2.ZERO):
	header_label.text = header_text
	body_label.text = body_text

	# Set position on the screen
	self.position = position

	show()

	timer.wait_time = duration
	timer.start()

func _on_disappear_timeout():
	hide()
