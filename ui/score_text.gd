extends Label
class_name ScoreText
export(int) var counter_stop = 9999999

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current_value = 0
var target_value = 0
onready var counter_digits = int(ceil(log(counter_stop + 1) / log(10)))
onready var counter_format = "%0" + str(counter_digits) + "d"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_target_value(val : int):
	target_value = min(counter_stop, val)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var diff = target_value - current_value
	if diff != 0:
		var exponent = floor(log(abs(diff)) / log(10))
		if exponent <= 1: exponent = 0 # Let counter jitter if the difference is less than 100
		current_value += sign(diff) * pow(10, exponent)
	text = counter_format % current_value
