extends Control

class_name Title

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var title_cg = $"%TitleCG"
onready var press_any_key = $"%PressAnyKey"

signal load_game

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func emit_load_game():
	emit_signal("load_game")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
