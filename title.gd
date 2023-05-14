extends Control

class_name Title

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var title_cg = $"%TitleCG"
onready var press_any_key = $"%PressAnyKey"
onready var audio_stream_player = $"%AudioStreamPlayer"
signal load_game

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func emit_load_game():
	emit_signal("load_game")
	var tween = audio_stream_player.create_tween()
	tween.tween_property(audio_stream_player, "volume_db", -40.0, 1.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
