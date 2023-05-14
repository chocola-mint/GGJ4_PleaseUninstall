extends CanvasLayer

class_name GameOverOverlay

signal restart

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var score_label : ScoreText = $"%ScoreText"
onready var control : Control = $"%Control"

# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = control.create_tween()
	control.modulate.a = 0
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(control, "modulate:a", 0.8, 1.0)
	tween = GameManager.fade_music(0.5)
	tween.tween_callback(GameManager, "play_music", [preload("res://sound/10 - The Empire.ogg")])
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if disabled: return
	score_label.snap_to_value(GameManager.score)
	if Input.is_action_just_pressed("restart"):
		disabled = true
		var _tween = GameManager.fade_music(0.5)
		emit_signal("restart")

var disabled = false
