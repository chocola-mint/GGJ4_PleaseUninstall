extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var _direction = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	self_modulate.a = 0

func set_highlight(is_active : bool):
	if is_active: _direction = 1
	else: _direction = -1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self_modulate.a = clamp(self_modulate.a + _direction * delta * 5, 0, 1)
