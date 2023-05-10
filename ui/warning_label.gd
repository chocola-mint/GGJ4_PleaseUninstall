extends Label

class_name WarningLabel

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var fade_direction = 1
var time = 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	modulate = Color(1.0, 1.0, 1.0, 0.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	modulate.a = clamp(modulate.a + delta * 4.0 * fade_direction, 0.0, 1.0)
	self_modulate.a = pow(cos(time * 4.0), 2.0) * 0.5 + 0.5
	time += delta
