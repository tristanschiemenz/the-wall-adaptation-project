extends Control

@onready var label: Label = $HBoxContainer/Label
@onready var button: Button = $HBoxContainer/Button

@export var action_name : String = "move_left"

func _ready() -> void:
	set_process_unhandled_key_input(false)
	set_action_name()
	set_text_for_key()


func set_action_name() -> void:
	label.text = "Unassigned"

	match action_name:
		"move_left":
			label.text = "Move Left"
		"move_right":
			label.text = "Move Right" 
		"move_up":
			label.text = "Move Up"     
		"move_down":
			label.text = "Move Down"   
		"shoot":
			label.text = "Shoot"      
		"interact":
			label.text = "Interact"  


func set_text_for_key() -> void:
	var action_events = InputMap.action_get_events(action_name)
	var action_event = action_events[0]
	if action_event is InputEventKey:
		var action_keycode = OS.get_keycode_string(action_event.physical_keycode)
		button.text = str(action_keycode)
	elif action_event is InputEventMouseButton:
		var mouse_button = action_event.button_index
		var button_name = ""
		
		match mouse_button:
			MOUSE_BUTTON_LEFT:
				button_name = "Left Click"
			MOUSE_BUTTON_RIGHT:
				button_name = "Right Click"
	
		button.text = button_name


func _on_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		button.text = "Press any key..."
		set_process_unhandled_key_input(toggled_on)
		
		for i in get_tree().get_nodes_in_group("hotkey_button"):
			if i.action_name != self.action_name:
				i.button.toggle_mode = false
				i.set_process_unhandled_key_input(false)
	else:
		
		for i in get_tree().get_nodes_in_group("hotkey_button"):
			if i.action_name != self.action_name:
				i.button.toggle_mode = true
				i.set_process_unhandled_key_input(false)
				
		set_text_for_key() 

func _unhandled_key_input(event: InputEvent) -> void:
	rebind_action_key(event)
	button.button_pressed = false
	
func rebind_action_key(event) -> void:
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name,event)
	
	set_process_unhandled_key_input(false)
	set_text_for_key()
	set_action_name()
