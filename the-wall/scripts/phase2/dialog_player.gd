extends Control
@onready var name_label: Label = $name_label
@onready var dialog_label: Label = $dialog_label
@onready var timer: Timer = $LetterDisplayTimer

var text = ""
var letter_index = 0

var letter_time = 0.03
var space_time = 0.06
var punctuation_time = 0.2


func _ready() -> void:
	hide()

func _hide() -> void:
	hide()

func display_text(name: String, dialog_text: String) -> void:
	name_label.text = name
	dialog_label.text = ""
	text = dialog_text
	letter_index = 0
	show()
	
	_display_letter()
	
func _display_letter() -> void:
	dialog_label.text += text[letter_index]
	
	letter_index += 1
	if letter_index >= text.length():
		return
	
	match text[letter_index]:
		"!", ",", ".", "?":
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_time)
 


func _on_letter_display_timer_timeout() -> void:
	_display_letter()
