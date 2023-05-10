extends TextureProgress

export(Gradient) var override_progress_gradient : Gradient

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	tint_progress = override_progress_gradient.interpolate(value)
	pass
