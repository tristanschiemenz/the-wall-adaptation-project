extends Control

@onready var option_button: OptionButton = $HBoxContainer/OptionButton

const RESOLUTION_DICTIONARY: Dictionary = {
	# Standard 16:9 Resolutions
	"1280 x 720": Vector2i(1280, 720),   # HD
	"1366 x 768": Vector2i(1366, 768),  # WXGA
	"1600 x 900": Vector2i(1600, 900),  # HD+
	"1920 x 1080": Vector2i(1920, 1080), # Full HD
	"2560 x 1440": Vector2i(2560, 1440), # QHD
	"3840 x 2160": Vector2i(3840, 2160), # 4K UHD
	
	# Legacy 4:3 Resolutions
	"800 x 600": Vector2i(800, 600),    # SVGA
	"1024 x 768": Vector2i(1024, 768),  # XGA
	
	# Wide 16:10 Resolutions
	"1280 x 800": Vector2i(1280, 800),  # WXGA
	"1440 x 900": Vector2i(1440, 900),  # WXGA+
	"1680 x 1050": Vector2i(1680, 1050), # WSXGA+
	
	# Ultra-Wide Resolutions
	"2560 x 1080": Vector2i(2560, 1080), # UWHD
	"3440 x 1440": Vector2i(3440, 1440)  # UWQHD
}

func _ready() -> void:
	add_resolution_items()
	option_button.selected = 3
	option_button.item_selected.connect(on_resolution_selected)
	
func add_resolution_items() -> void:
	for resolution_size_text in RESOLUTION_DICTIONARY:
		option_button.add_item(resolution_size_text)
	
func on_resolution_selected(index : int) -> void:
	DisplayServer.window_set_size(RESOLUTION_DICTIONARY.values()[index])
	
