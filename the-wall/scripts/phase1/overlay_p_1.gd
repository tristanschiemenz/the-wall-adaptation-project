extends CanvasLayer

@export var dayCount = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var daylabel = $DayLabel
	daylabel.text = "Day: " + str(dayCount)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func add_day() -> void:
	var daylabel = $DayLabel
	dayCount += 1
	daylabel.text = "Day: " + str(dayCount)
