extends Node

class_name GameUI

export(NodePath) onready var game = get_node(game) as Game

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var score_text : ScoreText = $"%ScoreText"
onready var power_gauge : TextureProgress = $"%PowerGauge"
onready var low_power_warning : WarningLabel = $"%LowPowerWarning"

# Called when the node enters the scene tree for the first time.
func _ready():
	power_gauge.min_value = 0
	power_gauge.max_value = 1.0
	power_gauge.step = 0.0001
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	score_text.set_target_value(GameManager.score)
	
	power_gauge.value = game.player.stats.power
	if game.player.stats.is_low_power():
		low_power_warning.fade_direction = 1
	else: low_power_warning.fade_direction = -1
