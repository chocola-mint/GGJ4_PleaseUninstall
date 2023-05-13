extends Node

class_name GameManagerUI

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var score_text : ScoreText = $"%ScoreText"
onready var power_gauge : TextureProgress = $"%PowerGauge"
onready var low_power_warning : WarningLabel = $"%LowPowerWarning"
onready var health_gauge : TextureProgress = $"%HealthGauge"
onready var low_health_warning : WarningLabel = $"%LowHealthWarning"
onready var health_container : HFlowContainer = $"%HealthContainer"
onready var low_health_vignette : TextureRect = $"%LowHealthVignette"
onready var time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	power_gauge.min_value = 0
	power_gauge.max_value = 1.0
	power_gauge.step = 0.0001
	
	health_gauge.min_value = 0
	health_gauge.max_value = 1.0
	health_gauge.step = 0.01
	low_health_vignette.modulate.a = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	score_text.set_target_value(GameManager.score)
	
	power_gauge.value = GameManager.player.stats.power
	if GameManager.player.stats.is_low_power():
		low_power_warning.fade_direction = 1
	else: low_power_warning.fade_direction = -1
	
	for i in range(min(GameManager.player.stats.health, health_container.get_child_count())):
		health_container.get_child(i).visible = true
	for i in range(GameManager.player.stats.health, health_container.get_child_count()):
		health_container.get_child(i).visible = false
	
	health_gauge.value = GameManager.player.stats.get_health_ratio()
	if GameManager.player.stats.health <= 2 and GameManager.player.stats.health > 0:
		low_health_warning.fade_direction = 1
		low_health_vignette.modulate.a = min(1, low_health_vignette.modulate.a + 4 * _delta)
	else: 
		low_health_warning.fade_direction = -1
		low_health_vignette.modulate.a = max(0, low_health_vignette.modulate.a - 4 * _delta)
	low_health_vignette.self_modulate.a = (cos(time / 2.0) / 2 + 0.5) * 0.5 + 0.5
	
	time += _delta
